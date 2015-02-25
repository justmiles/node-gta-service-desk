http = require('https')

module.exports = class ServiceDesk
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

# Incidents
  showIncidents:(params, callback) ->
    this.XHR 'GET', '/incidents.' + @format, params, null, (body) ->
      if (body)
        callback body

  showIncident:(id, callback) ->
    this.XHR 'GET', '/incidents/' + id + '.' + @format, null, null, (body) ->
      if (body)
        callback body.incident

  createIncident:(payload, callback) ->
    payload = incident: payload
    this.XHR 'POST', '/incidents.' + @format, null, payload, (body) ->
      if (body)
        callback body.incident
      else
        callback false
# Incidents

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
        return
      res.on 'end', ->
        try
          jsonResponse = JSON.parse(response)
        catch e
          console.log 'Could not parse response. ' + e
          return false
        if res.headers.status != '200 OK'
          console.log res.headers.status
        if jsonResponse.status == 'Success'
          callback jsonResponse.result
        else
          console.log 'Request failed'
          console.log jsonResponse.errors[0].error
          return false

    req.on 'error', (e) ->
      console.log 'HTTPS ERROR: ' + e

    req.write payloadString
    req.end

Object::toURL = ->
  obj = this
  '?' + Object.keys(obj).map((k) ->
    encodeURIComponent(k) + '=' + encodeURIComponent(obj[k])
  ).join('&')

# # # # # # # # # # # # # # # # # #
#     TODO: add below calls
#    Incidents API Calls
#      -Show Incidents (GET)
#      -Show Incident (GET)
#      -Create Incident (POST)
#      Update Incident (PUT)
#    Problems API Calls
#      Show Problems (GET)
#      Show Problem (GET)
#      Create Problem (POST)
#      Update Problem (PUT)
#    Changes API Calls
#      Show Changes (GET)
#      Show Change (GET)
#      Create Change (POST)
#      Update Change (PUT)
#    Releases API Calls
#      Show Releases (GET)
#      Show Release (GET)
#      Create Release (POST)
#      Update Release (PUT)
#    Configuration API Calls
#      Show Top-Level Config Types (GET)
#      Show Config Type (GET)
#      Show Config Relationship Types (GET)
#      Show Config Item (GET)
#      Create Config Item (POST)
#      Update Config Item (PUT)
#    Notes API Calls
#      Show Note (GET)
#      Update Note (PUT)
#      Create Note (POST)
#      Delete Note (DELETE)
#    Watches API Calls
#      Show Watches (GET)
#      Show Watch (GET)
#      Create Watch (POST)
#      Update Watch (PUT)
#      Delete Watch (DELETE)
#    Change Testers API Calls
#      Show Change Testers (GET)
#      Show Change Tester (GET)
#      Create Change Tester (POST)
#      Update Change Tester (PUT)
#      Delete Change Tester (DELETE)
#    Issues API Calls
#      Show Issues (GET)
#      Show Issue (GET)
#      Create Issue (POST)
#      Update Issue (PUT)
#    Review Users API Calls
#      Show Release Review Users (GET)
#      Show Release Review User (GET)
#      Create Release Review User (POST)
#      Update Release Review User (PUT)
#      Delete Release Review User (DELETE)
#    Release Records API Calls
#      Show Release Records (GET)  Show Release Record (GET)
#      Create Release Record (POST)
#      Update Release Record (PUT)
#    Time Entries API Calls
#      Show Time Entries (GET)
#      Show Time Entry (GET)
#      Show Time Entry (GET)
#      Create Time Entry (POST)
#      Delete Time Entry (DELETE)
#      Update Time Entry (PUT)
#    Links API Calls
#      Show Links (GET)
#      Create Link (POST)
#      Delete Link (DELETE)
#    Users API Calls
#      Show Users (GET)
#      Show User (GET)
#      Show Current User (GET)
#    Customers API Calls
#      Show Customers (GET)
#      Show Customer (GET)
#      Create Customer (POST)
#      Update Customer (PUT)
#    Companies API Calls
#      Show Companies (GET)
#      Show Company (GET)
#      Create Company (POST)
#      Update Company (PUT)
#    Services API Calls
#      Show Services (GET)
#      Show Service (GET)
#






















