ServiceDesk = require '../src/ServiceDesk'
nock = require 'nock'
mocks = require './mocks/mocks.coffee'

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
      serviceDesk = new ServiceDesk(mocks.enums.api_key)
      throw 'api key is null' if serviceDesk.api_key == null
      done()

  describe '#_request()', ->

    it 'TODO: _request() tests', (done) ->
      done()
