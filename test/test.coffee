assert = require('assert')
ServiceDesk = require('../index.js')
nock = require 'nock'
mocks = require './mockedAPI.coffee'
enums =
  api_key: 'aabbccddeeffgghhiijjkk'
  api_host: 'https://deskapi.gotoassist.com'

# Main ServiceDesk Library
describe 'ServiceDesk', ->

  describe '#constructor()', ->

    it 'API Key is not defined', (done) ->
      serviceDesk = {}
      try
        serviceDesk = new ServiceDesk()
      catch e
        throw 'No exeption thrown for missing API key' unless e
      finally
        throw 'Expected api_key to be empty' if serviceDesk.api_key
        done()

    it 'API Key is defined', (done) ->
      serviceDesk = new ServiceDesk(enums.api_key)
      throw 'nope' if serviceDesk.api_key == null
      done()

  describe '#_request()', ->

    it 'TODO: _request() tests', (done) ->
      done()

# Incidents
describe 'Incidents', ->

  describe '#getIncident()', ->

    nock(enums.api_host)
      .get("/v1/incidents/1.json")
      .reply(200, JSON.stringify(mocks.incidents[0]));

    it 'Get an incident', (done) ->
      serviceDesk = new ServiceDesk(enums.api_key)
      serviceDesk.getIncident 1, (err, res) ->
        throw err if err
        throw 'Did not receive an incident' unless res.incident
        done()

  describe '#createIncident()', ->

    nock(enums.api_host)
      .post("/v1/incidents.json")
      .reply(200, JSON.stringify(mocks.incidents[0]));

    it 'Create an incident', (done) ->
      serviceDesk = new ServiceDesk(enums.api_key)
      serviceDesk.createIncident mocks.incidents[0], (err, res) ->
        throw err if err
        throw 'Could not create incident' unless res.incident
        done()
