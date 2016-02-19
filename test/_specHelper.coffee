ServiceDesk = require '../src/ServiceDesk'
nock = require 'nock'
mocks = require './mocks/mocks.coffee'

beforeEach 'Instanciate ServiceDesk', (done) ->
  GLOBAL.serviceDesk = new ServiceDesk(mocks.enums.api_key)
  serviceDesk.delay = 5

  done()

afterEach ->
  delete serviceDesk
