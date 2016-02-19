nock = require 'nock'
mocks = require './mocks/mocks.coffee'

# Problems API Calls
describe 'Problems', ->

  describe '#getProblems()', ->

    nock(mocks.enums.api_host)
      .get('/v1/problems.json')
      .reply(200, JSON.stringify(mocks.successfulResponseWithProblems));

    it 'Get problems!', (done) ->
      serviceDesk.getProblems {}, (err, res) ->
        throw err if err
        throw new Error('No problems received') unless res[0].problem
        done()
