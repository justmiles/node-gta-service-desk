nock = require 'nock'
mocks = require './mocks/mocks.coffee'


describe 'Incidents', ->

  describe '#getIncident()', ->

    nock(mocks.enums.api_host)
      .get('/v1/incidents/1.json')
      .reply(200, JSON.stringify(mocks.successfulResponse));

    it 'Get an incident', (done) ->
      serviceDesk.getIncident 1, (err, res) ->
        throw err if err
        throw 'Did not receive an incident' unless res.incident
        done()

  describe '#createIncident()', ->

    nock(mocks.enums.api_host)
      .post("/v1/incidents.json")
      .reply(200, JSON.stringify(mocks.successfulResponse));

    it 'Create an incident', (done) ->
      serviceDesk.createIncident mocks.incidents[0], (err, res) ->
        throw err if err
        throw 'Could not create incident' unless res.incident
        done()

  describe '#updateIncident()', ->

    nock(mocks.enums.api_host)
      .put('/v1/incidents/1.json')
      .reply(200, JSON.stringify(mocks.successfulResponse));

    it 'Update an incident', (done) ->
      serviceDesk.updateIncident 1, mocks.incidents[0], (err, res) ->
        throw err if err
        throw 'Could not update incident' unless res.incident
        done()

  describe '#updateIncidentSymptom()', ->

    nock(mocks.enums.api_host)
      .put("/v1/incidents/1/comments/2.json")
      .query
        note_type: 'symptom'
      .reply(200, JSON.stringify(mocks.successfulResponse));

    it 'Update an incident symptom', (done) ->
      serviceDesk.updateIncidentSymptom 1, 2, 'Symptom: some string', (err, res) ->
        throw err if err
        throw 'Could not update incident' unless res.incident
        done()

  describe '#openIncident()', ->

    nock(mocks.enums.api_host)
      .put('/v1/incidents/1.json')
      .reply(200, JSON.stringify(mocks.successfulResponse))

    it 'Open or re-open incident', (done) ->
      serviceDesk.openIncident 1, (err, res) ->
        throw err if err
        throw 'Could not open incident' if res.incident?.closed_at
        done()

  describe '#closeIncident()', ->

    nock(mocks.enums.api_host)
      .put('/v1/incidents/1.json')
      .reply(200, JSON.stringify(mocks.successfulResponseWithClosedIncident))

    it 'Close incident', (done) ->
      serviceDesk.closeIncident 1, 'Close message', (err, res) ->
        throw err if err
        throw 'Could not close incident' unless res.incident.closed_at
        done()

  describe '#addIncidentComment()', ->

    nock(mocks.enums.api_host)
      .post('/v1/incidents/1/comments.json')
      .query(note_type: 'comments')
      .reply(200, JSON.stringify(mocks.successfulResponseWithClosedIncident))

    it 'Comment added', () ->
      serviceDesk.addIncidentComment 1, 'Test comment', (err, res) ->
        throw err if err
        #TODO: test for comment

  describe '#addIncidentResolution()', ->

    nock(mocks.enums.api_host)
      .post('/v1/incidents/1/resolutions.json')
      .query(note_type: 'resolutions')
      .reply(200, JSON.stringify(mocks.successfulResponseWithClosedIncident))

    it 'Resolution added', () ->
      serviceDesk.addIncidentResolution 1, 'Test resolution', (err, res) ->
        throw err if err
        #TODO: test for resolution

  describe '#resolveAndCloseIncident()', ->

      nock(mocks.enums.api_host)
        .post('/v1/incidents/1/resolutions.json')
        .query(note_type: 'resolutions')
        .reply(200, JSON.stringify(mocks.successfulResponseWithClosedIncident))

      nock(mocks.enums.api_host)
        .put('/v1/incidents/1.json')
        .reply(200, JSON.stringify(mocks.successfulResponseWithComment))

    it 'Resolution added', () ->
      serviceDesk.addIncidentResolution 1, 'Test resolution', (err, res) ->
        throw err if err
        #TODO: test for resolution
