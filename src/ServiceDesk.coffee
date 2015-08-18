http = require("https")

class ServiceDesk
  constructor: (apiKey) ->
    @apiKey = process.env.SERVICE_DESK_KEY or apiKey
    @host = process.env.SERVICE_DESK_HOST or "deskapi.gotoassist.com"
    @apiVersion = process.env.SERVICE_DESK_VERSION or "v1"

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
    @_request "POST", "changes.json", null, payload, callback

  updateChange:(id, payload, callback) ->
    payload = change: payload
    @_request "PUT", "changes/#{id}.json", null, null, callback

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
    payload = release: payload
    @_request "POST", "releases.json", null, payload, callback

  updateRelease:(id, payload, callback) ->
    payload = release: payload
    @_request "PUT", "releases/#{id}.json", null, null, callback

  updateIncidentSymptom:(ticketId, symptomId, message, callback) ->
    params =
      note_type : "symptom"

    payload =
      symptom: {}
    payload.symptom.note = message

    @_request "PUT", "incidents/#{ticketId}/comments/#{symptomId}.json", params, payload, callback

  #  utils
  _request:(method, api, params, payload, callback) ->
    unless params?
      params = ''
    else
      params = @_toURL(params)

    payloadString = JSON.stringify(payload)

    options =
      host: @host
      path: "/#{@apiVersion}/#{api}#{params}"
      method: method
      auth: "x:#{@apiKey}"
      headers:
        "Content-Type": "application/json"
        "Content-Length": payloadString.length

    req = http.request options, (res) ->
      res.setEncoding "utf8"
      response = ""

      res.on "data", (data) ->
        response += data

      res.on "end", ->
        try
          jsonResponse = JSON.parse response

        catch e
          return callback "Could not parse as JSON response. #{e}. Received #{response}"

        if res.headers.status != "200 OK"
          msg = "[ERROR] #{res.statusCode}: #{res.headers.status}"
          return callback msg, jsonResponse

        else if jsonResponse.status == 'Failed'
          return callback jsonResponse.errors[0].error, jsonResponse

        else
          return callback null, jsonResponse.result

    req.on "error", (e) ->
      console.log "HTTPS ERROR: " + e

    req.write payloadString
    req.end

  _toURL: (obj)->
    return "?" + Object.keys(obj).map((k) ->
        encodeURIComponent(k) + "=" + encodeURIComponent(obj[k])
      ).join("&")

module.exports = ServiceDesk
