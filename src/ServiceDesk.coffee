request = require('request')
log   = require('debug-logger')("ServiceDesk")
async = require 'async'

class ServiceDesk
  constructor: (@apiKey, @concurrency = 1) ->
    @apiKey or= process.env.SERVICE_DESK_API_KEY
    unless @apiKey
      throw 'ERROR: Service Desk API key is not set. Try instantiating with "new ServiceDesk(\'your_api_key\')" or setting the SERVICE_DESK_API_KEY environment variable'
    @host = process.env.SERVICE_DESK_HOST or "deskapi.gotoassist.com"
    @apiVersion = process.env.SERVICE_DESK_VERSION or "v1"
    @delay = 500

  #  utils

  _queue: async.queue ((task, callback) ->

    options =
      url: "https://#{task.host}/#{task.apiVersion}/#{task.api}"
      method: task.method
      headers:
        authorization: "Basic " + new Buffer('x:' + task.apiKey).toString("base64")
      json: true
    options.qs = task.params if task.params
    options.body = task.payload if task.payload

    log.debug 'Request options', options
    log.debug 'Request payload', task.payload if task.payload

    setTimeout (->
      request options, (err, res, body) ->
        GLOBAL.calls or= 0
        calls += 1
        log.debug "API Call Counter: #{calls}"
        log.warn "Error", err if err
        log.debug "Response Body", body

        return callback new Error('No response received') unless res

        if res.statusCode != 200
          return callback new Error("[ERROR] #{res.statusCode}"), body

        else if body.status == 'Failed'
          return callback new Error(body.errors[0].error), body

        else unless body.result
          return callback new Error('No "result" in body'), body

        else
          return callback null, body.result

    ), task.delay

  ), @concurrency

  _request:(method, api, params, payload, callback) ->
    task =
      method: method
      api: api
      params: params
      payload: payload
      host: @host
      apiVersion: @apiVersion
      apiKey: @apiKey
      delay: @delay

    @_queue.push task, callback

  getTicket:(type, id, params, callback) ->
    if type not in ['incident', 'change', 'release', 'problem']
      return callback "Ticket type '#{type} is not known."
    @_request "GET", "#{type}s/#{id}.json", params, null, callback

  getReport:(type, reportId, params = {}, callback) ->
    if type not in ['incident', 'change', 'release', 'problem']
      return callback "Report type '#{type} is not known."
    params.report_id = reportId
    @_request "GET", "#{type}s.json", params, null, callback

  # Incidents API Calls
  getIncidents:(params, callback) ->
    @_request "GET", "incidents.json", params, null, callback

  getIncidentReport:(reportId, params = {}, callback) ->
    params.report_id = reportId
    @_request "GET", "incidents.json", params, null, callback

  getIncident:(id, callback) ->
    @_request "GET", "incidents/#{id}.json", null, null, callback

  createIncident:(payload, callback) ->
    # NOTE: you can update the symptom by simply passing in "symptom" String inside the Incident object. This is not documented by GTA.
    payload = incident: payload
    @_request "POST", "incidents.json", null, payload, callback

  updateIncident:(id, payload, callback) ->
    payload = incident: payload
    @_request "PUT", "incidents/#{id}.json", null, payload, callback

  updateIncidentSymptom:(ticketId, symptomId, message, callback) ->
    params = note_type : "symptom"
    payload = symptom: {}
    payload.symptom.note = message
    @_request "PUT", "incidents/#{ticketId}/comments/#{symptomId}.json", params, payload, callback

  openIncident:(id, callback) ->
    incident =
      closed_at: ''
      closure_code: ''
    @updateIncident id, incident, callback

  closeIncident:(id, message, callback) ->
    now = new Date()
    incident =
      closed_at: now
      resolved_at: now
      closure_code: 0
      closure_comment: message
    @updateIncident id, incident, callback

  addIncidentComment:(id, comment, callback) ->
    payload = comment: note: comment
    @createNote 'incidents', id, 'comments', payload, callback

  addIncidentResolution:(id, resolution, callback) ->
    payload = resolution: note: resolution
    @createNote 'incidents', id, 'resolutions', payload, callback

  resolveAndCloseIncident:(id, resolution, callback) ->
    serviceDesk = this
    @addIncidentResolution id, resolution, (err, res) ->
      return callback err, res if err
      serviceDesk.closeIncident id, 'Closing because incident is resolved.', callback

  #  Notes API Calls
  getNote:(parent, parentId, type, id, callback) ->
    @_request "GET", "#{parent}/#{parentId}/#{type}/#{id}.json", null, null, callback

  createNote:(parent, parentId, type, payload, callback) ->
    params = note_type: type
#    params = note_type: type.replace(/s$/,'')
    @_request "POST", "#{parent}/#{parentId}/#{type}.json", params, payload, callback

  #  Problems API Calls
  getProblems:(params, callback) ->
    @_request "GET", "problems.json", params, null, callback

  getProblem:(id, callback) ->
    @_request "GET", "problems/#{id}.json", null, null, callback

  createProblem:(payload, callback) ->
    payload = problem: payload
    @_request "POST", "problems.json", null, payload, callback

  updateProblem:(id, payload, callback) ->
    payload = problem: payload
    @_request "PUT", "problems/#{id}.json", null, null, callback

  #  Changes API Calls
  getChanges:(params, callback) ->
    @_request "GET", "changes.json", params, null, callback

  getChange:(id, callback) ->
    @_request "GET", "changes/#{id}.json", null, null, callback

  createChange:(payload, callback) ->
    payload = change: payload
    serviceDesk = @
    @_request "POST", "changes.json", null, payload, (err, change) ->
      callback err, change
      return if err
      if payload.change.reason
        serviceDesk.setChangeReason change.change.id, payload.change.reason, log.debug
      if payload.change.description
        if change.change.descriptions?[0]?.description?.id
          serviceDesk.updateChangeDescription change.change.id, change.change.descriptions[0].description.id, payload.change.description, log.debug
        else
          serviceDesk.setChangeDescription change.change.id, payload.change.description, log.debug
      if payload.change.build_instruction
        serviceDesk.setChangeBuildInstruction change.change.id, payload.change.build_instruction, log.debug
      if payload.change.build_progress_note
        serviceDesk.addChangeBuildProgress change.change.id, payload.change.build_progress_note, log.debug


  linkChangeToIncident: (changeId, incidentId, callback) ->
    payload = release_id: incidentId
    @_request "POST", "links/changes/#{changeId}", null, payload, callback

  linkChangeToRelease: (changeId, releaseId, callback) ->
    payload = release_id: releaseId
    @_request "POST", "links/changes/#{changeId}", null, payload, callback

  linkChangeToProblem: (changeId, problemId, callback) ->
    payload = problem_id: problemId
    @_request "POST", "links/changes/#{changeId}", null, payload, callback

  linkChangeToChange: (changeId, secondChangeId, callback) ->
    payload = change_id: secondChangeId
    @_request "POST", "links/changes/#{changeId}", null, payload, callback

  updateChange:(id, payload, callback) ->
    payload = change: payload
    @_request "PUT", "changes/#{id}.json", null, null, callback

  setChangeDescription:(id, description, callback) ->
    sd = @
    payload = description: note: description
    @createNote 'changes', id, 'descriptions', payload, callback

  deleteChangeDescription:(changeId, descriptionId, callback) ->
    params = note_type : 'description'
    @_request "DELETE", "changes/#{changeId}/descriptions/#{descriptionId}.json", params, null, callback
    @createNote 'changes', id, 'descriptions', payload, callback

  updateChangeDescription:(changeId, descriptionId, description, callback) ->
    params = note_type : 'description'
    payload = description: note: description
    @_request "PUT", "changes/#{changeId}/descriptions/#{descriptionId}.json", params, payload, callback

  getChangeDescription:(changeId, descriptionId, callback) ->
    @_request "GET", "changes/#{changeId}/descriptions/#{descriptionId}.json", null, null, callback

  setChangeReason:(id, reason, callback) ->
    payload = reason: note: reason
    @createNote 'changes', id, 'reasons', payload, callback

  setChangeBuildInstruction:(id, instruction, callback) ->
    payload = build_instruction: note: instruction
    @createNote 'changes', id, 'build_instructions', payload, callback

  addChangeBuildProgress:(id, instruction, callback) ->
    payload = build_progress_note: note: instruction
    @createNote 'changes', id, 'build_progress_notes', payload, callback

#  addChangeTestPlan:(id, plan, callback) ->
#    payload = test_plan: note: plan
#    @createNote 'changes', id, 'test_plans', payload, callback

  getChangeTesters:(id, callback) ->
    @_request 'GET', "changes/#{id}/testers.json", null, null, callback

  getChangePlans:(id, callback) ->
    @_request 'GET', "changes/#{id}/test_plans.json", null, null, callback

  #  Watches API Calls
  createIncidentWatch:(incident_id, payload, callback) ->
    payload = watch: payload
    @_request "POST", "incidents/#{incident_id}/watches.json", null, payload, callback

  #  Release API Calls
  getReleases:(params, callback) ->
    @_request "GET", "releases.json", params, null, callback

  getRelease:(id, callback) ->
    @_request "GET", "releases/#{id}.json", null, null, callback

  createRelease:(payload, callback) ->
    if payload.component
      payload.release_component = payload.component
    payload = release: payload
    serviceDesk = @
    @_request "POST", "releases.json", null, payload, (err, release) ->
      callback err, release
      return if err
      if payload.release.backout
        serviceDesk.setReleaseBackoutPlan release.release.id, payload.release.backout, log.debug
      if payload.release.component
        if release.release_components?[0]?.component.id
          serviceDesk.updateReleaseComponent release.release.id, release.release.release_components[0].component.id, payload.release.component, log.debug
        else
          serviceDesk.setReleaseComponent release.release.id, payload.release.component, log.debug

  updateRelease:(id, payload, callback) ->
    payload = release: payload
    @_request "PUT", "releases/#{id}.json", null, payload, callback

  setReleaseComponent:(id, component, callback) ->
    sd = @
    @getRelease id, (err, res) ->
      return callback err, res if err
      if res.release.release_components[0]?.release_component?.id
        sd.updateReleaseComponent id, res.release.release_components[0].release_component.id, component, callback
      else
        payload = component: note: component
        sd.createNote 'releases', id, 'components', payload, callback

  updateReleaseComponent:(releaseId, componentId, component, callback) ->
    params = note_type : 'component'
    payload = component: note: component
    @_request "PUT", "releases/#{releaseId}/components/#{componentId}.json", params, payload, callback

  setReleaseInstruction:(id, instruction, callback) ->
    payload = instruction: note: instruction
    @createNote 'releases', id, 'instructions', payload, callback

  setReleaseBackoutPlan:(id, backout, callback) ->
    payload = backout: note: backout
    @createNote 'releases', id, 'backouts', payload, callback

  addReleaseComment:(id, comment, callback) ->
    payload = comment: note: comment
    @createNote 'releases', id, 'comments', payload, callback

  #  Customers API Calls
  getCustomers:(params, callback) ->
    @_request "GET", "customers.json", params, null, callback

  createCustomer:(payload, callback) ->
    payload = release: payload
    @_request "POST", "releases.json", null, payload, callback

  createOrUpdateCustomer:(payload, callback) ->
    payload = release: payload
    @_request "POST", "releases.json", null, payload, callback

  #  Services API Calls
  getServices:(callback) ->
    payload = release: payload
    @_request "GET", "services.json", null, payload, callback

  getService:(id, callback) ->
    payload = release: payload
    @_request "GET", "services/#{id}.json", null, payload, callback

module.exports = ServiceDesk
