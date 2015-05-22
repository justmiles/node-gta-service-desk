http = require("https")

class ServiceDesk
  constructor: (apiKey) ->
    process.env.SERVICE_DESK_KEY = apiKey
    process.env.SERVICE_DESK_HOST = "deskapi.gotoassist.com"
    process.env.SERVICE_DESK_VERSION = "v1"

  # Incidents API Calls
  showIncidents:(params, callback) ->
    this.XHR "GET", "/incidents.json", params, null, callback

  showIncident:(id, callback) ->
    this.XHR "GET", "/incidents/#{id}.json", null, null, callback

  createIncident:(payload, callback) ->
    # NOTE: you can update the symptom by simply passing in "symptom" String inside the Incident object. This is not documented by GTA.
    payload = incident: payload
    this.XHR "POST", "/incidents.json", null, payload, callback

  updateIncident:(id, payload, callback) ->
    payload = incident: payload
    this.XHR "PUT", "/incidents/#{id}.json", null, payload, callback

  #  Problems API Calls
  showProblems:(params, callback) ->
    this.XHR "GET", "/problems.json", params, null, callback

  showProblem:(id, callback) ->
    this.XHR "GET", "/problems/#{id}.json", null, null, callback

  createProblem:(payload, callback) ->
    payload = problem: payload
    this.XHR "POST", "/problems.json", null, payload, callback

  updateProblem:(id, payload, callback) ->
    payload = problem: payload
    this.XHR "PUT", "/problems/#{id}.json", null, null, callback

  #  Changes API Calls
  showChanges:(params, callback) ->
    this.XHR "GET", "/changes.json", params, null, callback

  showChange:(id, callback) ->
    this.XHR "GET", "/changes/#{id}.json", null, null, callback

  createChange:(payload, callback) ->
    payload = change: payload
    this.XHR "POST", "/changes.json", null, payload, callback

  updateChange:(id, payload, callback) ->
    payload = change: payload
    this.XHR "PUT", "/changes/#{id}.json", null, null, callback

  #  Watches API Calls
  createIncidentWatch:(incident_id, payload, callback) ->
    payload = watch: payload
    this.XHR "POST", "/incidents/#{incident_id}/watches.json", null, payload, callback

  #  Release API Calls
  showReleases:(params, callback) ->
    this.XHR "GET", "/releases.json", params, null, callback

  showRelease:(id, callback) ->
    this.XHR "GET", "/releases/#{id}.json", null, null, callback

  createRelease:(payload, callback) ->
    payload = release: payload
    this.XHR "POST", "/releases.json", null, payload, callback

  updateRelease:(id, payload, callback) ->
    payload = release: payload
    this.XHR "PUT", "/releases/#{id}.json", null, null, callback

  updateIncidentSymptom:(ticketId, symptomId, message, callback) ->
    params =
      note_type : "symptom"

    payload =
      symptom: {}
    payload.symptom.note = message

    this.XHR "PUT", "/incidents/#{ticketId}/comments/#{symptomId}.json", params, payload, callback

  #  utils
  XHR:(method, api, params, payload, callback) ->
    if params == null
      params = ""
    else
      params = ServiceDesk._toURL(params)

    payloadString = JSON.stringify(payload)

    options =
      host: process.env.SERVICE_DESK_HOST
      path: "/" + process.env.SERVICE_DESK_VERSION + api + params
      method: method
      auth: "x:" + process.env.SERVICE_DESK_KEY
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
          jsonResponse = JSON.parse(response)
        catch e
          console.log "Could not parse response. " + e

        if res.headers.status != "200 OK"
          console.log "headers: " + res.headers.status

        if jsonResponse.status == "Success"
          callback jsonResponse.result, false

        else
          console.log "Request failed"
          console.log "Error: " + jsonResponse.errors[0].error
          callback false, jsonResponse.errors
    req.on "error", (e) ->
      console.log "HTTPS ERROR: " + e

    req.write payloadString
    req.end

  _toURL: (obj)->
    return "?" + Object.keys(obj).map((k) ->
        encodeURIComponent(k) + "=" + encodeURIComponent(obj[k])
      ).join("&")

module.exports = ServiceDesk
