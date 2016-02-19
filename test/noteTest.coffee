nock = require 'nock'
mocks = require './mocks/mocks.coffee'

# Notes API Calls
describe 'Notes', ->

  describe '#getNote()', ->

    nock(mocks.enums.api_host)
      .get('/v1/incidents/1/comments/1.json')
      .reply(200, JSON.stringify(mocks.successfulResponseWithComment));

    it 'Get a note', (done) ->
      serviceDesk.getNote 'incidents', 1, 'comments', 1, (err, res) ->
        throw err if err
        throw new Error('No comment received') unless res.comment
        done()

  describe '#createNote()', ->

    nock(mocks.enums.api_host)
      .post('/v1/incidents/1/comments.json')
      .query(note_type: 'comments')
      .reply(200, JSON.stringify(mocks.successfulResponseWithComment));

    it 'Create a note', (done) ->
      serviceDesk.createNote 'incidents', 1, 'comments', mocks.comment, (err, res) ->
        throw err if err
        throw new Error('No comment received') unless res.comment
        done()
