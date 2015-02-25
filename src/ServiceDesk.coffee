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

































