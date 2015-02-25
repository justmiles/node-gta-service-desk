http = require('https')

class ServiceDesk
  constructor: (apiKey) ->
    @apiKey = apiKey
    @apiHost = 'deskapi.gotoassist.com'
    @apiVersion = 'v1'
    @format = 'json'

  setApiKey:(apiKey) ->
    @apiKey = apiKey
    return @apiKey

  setApiURL:(apiURL) ->
    @apiURL = apiURL
    return @apiURL

  # Incidents API Calls
  showIncidents:(params, callback) ->
    this.XHR 'GET', '/incidents.' + @format, params, null, callback

  showIncident:(id, callback) ->
    this.XHR 'GET', '/incidents/' + id + '.' + @format, null, null, callback

  createIncident:(payload, callback) ->
    payload = incident: payload
    this.XHR 'POST', '/incidents.' + @format, null, payload, callback

  updateIncident:(id, payload, callback) ->
    payload = incident: payload
    this.XHR 'PUT', '/incidents/' + id + '.' + @format, null, null, callback

  #  Problems API Calls
  showProblems:(params, callback) ->
    this.XHR 'GET', '/problems.' + @format, params, null, callback

  showProblem:(id, callback) ->
    this.XHR 'GET', '/problems/' + id + '.' + @format, null, null, callback

  createProblem:(payload, callback) ->
    payload = problem: payload
    this.XHR 'POST', '/problems.' + @format, null, payload, callback

  updateProblem:(id, payload, callback) ->
    payload = problem: payload
    this.XHR 'PUT', '/problems/' + id + '.' + @format, null, null, callback

  #  Changes API Calls
  showChanges:(params, callback) ->
    this.XHR 'GET', '/changes.' + @format, params, null, callback

  showChange:(id, callback) ->
    this.XHR 'GET', '/changes/' + id + '.' + @format, null, null, callback

  createChange:(payload, callback) ->
    payload = change: payload
    this.XHR 'POST', '/changes.' + @format, null, payload, callback

  updateChange:(id, payload, callback) ->
    payload = change: payload
    this.XHR 'PUT', '/changes/' + id + '.' + @format, null, null, callback

  #  Release API Calls
  showReleases:(params, callback) ->
    this.XHR 'GET', '/releases.' + @format, params, null, callback

  showRelease:(id, callback) ->
    this.XHR 'GET', '/releases/' + id + '.' + @format, null, null, callback

  createRelease:(payload, callback) ->
    payload = release: payload
    this.XHR 'POST', '/releases.' + @format, null, payload, callback

  updateRelease:(id, payload, callback) ->
    payload = release: payload
    this.XHR 'PUT', '/releases/' + id + '.' + @format, null, null, callback

  #  utils
  XHR:(method, api, params, payload, callback) ->
    if params == null
      params = ''
    else
      params = params.toURL()

    payloadString = JSON.stringify(payload)

    options =
      host: @apiHost
      path: '/' + @apiVersion + api + params
      method: method
      auth: 'x:' + @apiKey
      headers:
        'Content-Type': 'application/json'
        'Content-Length': payloadString.length

    req = http.request options, (res) ->
      res.setEncoding 'utf8'
      response = ''

      res.on 'data', (data) ->
        response += data

      res.on 'end', ->
        try
          jsonResponse = JSON.parse(response)
        catch e
          console.log 'Could not parse response. ' + e

        if res.headers.status != '200 OK'
          console.log 'headers: ' + res.headers.status
        if jsonResponse.status == 'Success'
          callback jsonResponse.result

        else
          console.log 'Request failed'
          console.log 'Error: ' + jsonResponse.errors[0].error
          callback false
    req.on 'error', (e) ->
      console.log 'HTTPS ERROR: ' + e

    req.write payloadString
    req.end

Object::toURL = ->
  obj = this
  '?' + Object.keys(obj).map((k) ->
    encodeURIComponent(k) + '=' + encodeURIComponent(obj[k])
  ).join('&')

module.exports = ServiceDesk

# # # # # # # # # # # # # # # # # #
#    Incidents API Calls
#      Show Incidents (GET)
#      Show Incident (GET)
#      Create Incident (POST)
#      TODO: Update Incident (PUT)
#    Problems API Calls
#      Show Problems (GET)
#      Show Problem (GET)
#      TODO: Create Problem (POST)
#      TODO: Update Problem (PUT)
#    Changes API Calls
#      Show Changes (GET)
#      TODO: Show Change (GET)
#      TODO: Create Change (POST)
#      TODO: Update Change (PUT)
#    Releases API Calls
#      TODO: Show Releases (GET)
#      TODO: Show Release (GET)
#      TODO: Create Release (POST)
#      TODO: Update Release (PUT)
#    Configuration API Calls
#      TODO: Show Top-Level Config Types (GET)
#      TODO: Show Config Type (GET)
#      TODO: Show Config Relationship Types (GET)
#      TODO: Show Config Item (GET)
#      TODO: Create Config Item (POST)
#      TODO: Update Config Item (PUT)
#    Notes API Calls
#      TODO: Show Note (GET)
#      TODO: Update Note (PUT)
#      TODO: Create Note (POST)
#      TODO: Delete Note (DELETE)
#    Watches API Calls
#      TODO: Show Watches (GET)
#      TODO: Show Watch (GET)
#      TODO: Create Watch (POST)
#      TODO: Update Watch (PUT)
#      TODO: Delete Watch (DELETE)
#    Change Testers API Calls
#      TODO: Show Change Testers (GET)
#      TODO: Show Change Tester (GET)
#      TODO: Create Change Tester (POST)
#      TODO: Update Change Tester (PUT)
#      TODO: Delete Change Tester (DELETE)
#    Issues API Calls
#      TODO: Show Issues (GET)
#      TODO: Show Issue (GET)
#      TODO: Create Issue (POST)
#      TODO: Update Issue (PUT)
#    Review Users API Calls
#      TODO: Show Release Review Users (GET)
#      TODO: Show Release Review User (GET)
#      TODO: Create Release Review User (POST)
#      TODO: Update Release Review User (PUT)
#      TODO: Delete Release Review User (DELETE)
#    Release Records API Calls
#      TODO: Show Release Records (GET)
#      TODO: Show Release Record (GET)
#      TODO: Create Release Record (POST)
#      TODO: Update Release Record (PUT)
#    Time Entries API Calls
#      TODO: Show Time Entries (GET)
#      TODO: Show Time Entry (GET)
#      TODO: Show Time Entry (GET)
#      TODO: Create Time Entry (POST)
#      TODO: Delete Time Entry (DELETE)
#      TODO: Update Time Entry (PUT)
#    Links API Calls
#      TODO: Show Links (GET)
#      TODO: Create Link (POST)
#      TODO: Delete Link (DELETE)
#    Users API Calls
#      TODO: Show Users (GET)
#      TODO: Show User (GET)
#      TODO: Show Current User (GET)
#    Customers API Calls
#      TODO: Show Customers (GET)
#      TODO: Show Customer (GET)
#      TODO: Create Customer (POST)
#      TODO: Update Customer (PUT)
#    Companies API Calls
#      TODO: Show Companies (GET)
#      TODO: Show Company (GET)
#      TODO: Create Company (POST)
#      TODO: Update Company (PUT)
#    Services API Calls
#      TODO: Show Services (GET)
#      TODO: Show Service (GET)
# # # # # # # # # # # # # # # # # #






















