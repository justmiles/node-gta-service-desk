ServiceDesk = require '../src/ServiceDesk'
nock = require 'nock'
mocks = require './mocks.coffee'
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
  serviceDesk = new ServiceDesk(enums.api_key)

  describe '#getIncident()', ->

    nock(enums.api_host)
      .get('/v1/incidents/1.json')
      .reply(200, JSON.stringify(mocks.successfulResponse));

    it 'Get an incident', (done) ->
      serviceDesk.getIncident 1, (err, res) ->
        throw err if err
        throw 'Did not receive an incident' unless res.incident
        done()

  describe '#createIncident()', ->

    nock(enums.api_host)
      .post("/v1/incidents.json")
      .reply(200, JSON.stringify(mocks.successfulResponse));

    it 'Create an incident', (done) ->
      serviceDesk.createIncident mocks.incidents[0], (err, res) ->
        throw err if err
        throw 'Could not create incident' unless res.incident
        done()

  describe '#updateIncident()', ->

    nock(enums.api_host)
      .put('/v1/incidents/1.json')
      .reply(200, JSON.stringify(mocks.successfulResponse));

    it 'Update an incident', (done) ->
      serviceDesk.updateIncident 1, mocks.incidents[0], (err, res) ->
        throw err if err
        throw 'Could not update incident' unless res.incident
        done()

  describe '#updateIncidentSymptom()', ->

    nock(enums.api_host)
      .put("/v1/incidents/1/comments/2.json")
      .query
        note_type: 'symptom'
      .reply(200, JSON.stringify(mocks.successfulResponse));

    it 'Update an incident symptom', (done) ->
      serviceDesk.updateIncidentSymptom 1, 2, 'test', (err, res) ->
        throw err if err
        throw 'Could not update incident' unless res.incident
        done()

  describe '#openIncident()', ->

    nock(enums.api_host)
      .put('/v1/incidents/1.json')
      .reply(200, JSON.stringify(mocks.successfulResponse))

    it 'Open or re-open incident', (done) ->
      serviceDesk.openIncident 1, (err, res) ->
        throw err if err
        throw 'Could not open incident' if res.incident?.closed_at
        done()

  describe '#closeIncident()', ->

    nock(enums.api_host)
      .put('/v1/incidents/1.json')
      .reply(200, JSON.stringify(mocks.successfulResponseWithClosedIncident))

    it 'Close incident', (done) ->
      serviceDesk.closeIncident 1, 'Close message', (err, res) ->
        throw err if err
        throw 'Could not close incident' unless res.incident.closed_at
        done()

  describe '#addIncidentComment()', ->

    nock(enums.api_host)
      .post('/v1/incidents/1/comments.json')
      .query(note_type: 'comments')
      .reply(200, JSON.stringify(mocks.successfulResponseWithClosedIncident))

    it 'Comment added', (done) ->
      serviceDesk.addIncidentComment 1, 'Test comment', (err, res) ->
        throw err if err
        #TODO: test for comment
        done()

  describe '#addIncidentResolution()', ->

    nock(enums.api_host)
      .post('/v1/incidents/1/resolutions.json')
      .query(note_type: 'resolutions')
      .reply(200, JSON.stringify(mocks.successfulResponseWithClosedIncident))

    it 'Resolution added', (done) ->
      serviceDesk.addIncidentResolution 1, 'Test resolution', (err, res) ->
        throw err if err
        #TODO: test for resolution
        done()

  describe '#resolveAndCloseIncident()', ->

    nock(enums.api_host)
      .post('/v1/incidents/1/resolutions.json')
      .query(note_type: 'resolutions')
      .reply(200, JSON.stringify(mocks.successfulResponseWithClosedIncident))

    nock(enums.api_host)
      .put('/v1/incidents/1.json')
      .reply(200, JSON.stringify(mocks.successfulResponseWithComment))

    it 'Resolution added', (done) ->
      serviceDesk.resolveAndCloseIncident 1, 'Test resolution', (err, res) ->
        throw err if err
        #TODO: test for resolution
        #TODO: test for closure
        done()

# Notes API Calls
describe 'Notes', ->
  serviceDesk = new ServiceDesk(enums.api_key)

  describe '#getNote()', ->

    nock(enums.api_host)
      .get('/v1/incidents/1/comments/1.json')
      .reply(200, JSON.stringify(mocks.successfulResponseWithComment));

    it 'Get a note', (done) ->
      serviceDesk.getNote 'incidents', 1, 'comments', 1, (err, res) ->
        throw err if err
        throw new Error('No comment received') unless res.comment
        done()

  describe '#createNote()', ->

    nock(enums.api_host)
      .post('/v1/incidents/1/comments.json')
      .query(note_type: 'comments')
      .reply(200, JSON.stringify(mocks.successfulResponseWithComment));

    it 'Create a note', (done) ->
      serviceDesk.createNote 'incidents', 1, 'comments', mocks.comment, (err, res) ->
        throw err if err
        throw new Error('No comment received') unless res.comment
        done()

# Problems API Calls
describe 'Problems', ->
  serviceDesk = new ServiceDesk(enums.api_key)

  describe '#getProblems()', ->

    nock(enums.api_host)
    .get('/v1/problems.json')
    .reply(200, JSON.stringify(mocks.successfulResponseWithProblems));

    it 'Get problems!', (done) ->
      serviceDesk.getProblems {}, (err, res) ->
        throw err if err
        throw new Error('No problems received') unless res[0].problem
        done()
