nock = require 'nock'

closedIncident =
  'incident':
    'title': 'SFDC Sandbox Refresh'
    'priority':
      'id': 1
      'description': 'Very Important'
      'level': 1
    'closed_at': '2012-10-18T09:29:42-05:00'
    'created_at': '2012-10-17T13:53:14-05:00'
    'due_date': '2012-10-18T13:53:00-05:00'
    'assigned_user':
      'id': 101
      'first_name': 'Test'
      'last_name': 'User'
    'resolved_at': '2012-10-18T09:29:00-05:00'
    'occurred_at': '2012-10-17T13:53:00-05:00'
    'service':
      'id': 1
      'name': 'SomeService'
      'service_link': '/v1/services/1'
    'time_zone': 'Central Time (US & Canada)'
    'incident_link': '/v1/incidents/1024'
    'id': 1024
    'status': 'Resolved'
    'type':
      'id': 2
      'name': 'Service Request'
    'comments': [
      'comment':
        'id': 2
        'created_at': '2012-10-18T09:29:42-05:00'
        'note': 'This is an example comment'
        'user':
          'id': 101
          'first_name': 'Test'
          'last_name': 'User'
          'avatar': ''
        ]
    'symptoms': [
      'symptom':
        'id': 100
        'created_at': '2012-10-17T13:53:15-05:00'
        'note': 'This is an example symptom'
        'user':
          'id': 101
          'first_name': 'Test'
          'last_name': 'User'
      ]
    'resolutions': []
    'additional_values': {}
    'total_time_spent': 0
    'incidents': []
    'changes': []
    'releases': []
    'problems': []

openIncident =
  'incident':
    'title': 'SFDC Sandbox Refresh'
    'priority':
      'id': 1
      'description': 'Very Important'
      'level': 1
    'created_at': '2012-10-17T13:53:14-05:00'
    'due_date': '2012-10-18T13:53:00-05:00'
    'assigned_user':
      'id': 101
      'first_name': 'Test'
      'last_name': 'User'
    'resolved_at': '2012-10-18T09:29:00-05:00'
    'occurred_at': '2012-10-17T13:53:00-05:00'
    'service':
      'id': 1
      'name': 'SomeService'
      'service_link': '/v1/services/1'
    'time_zone': 'Central Time (US & Canada)'
    'incident_link': '/v1/incidents/1024'
    'id': 1024
    'status': 'Resolved'
    'type':
      'id': 2
      'name': 'Service Request'
    'comments': [
      'comment':
        'id': 2
        'created_at': '2012-10-18T09:29:42-05:00'
        'note': 'This is an example comment'
        'user':
          'id': 101
          'first_name': 'Test'
          'last_name': 'User'
          'avatar': ''
    ]
    'symptoms': [
      'symptom':
        'id': 100
        'created_at': '2012-10-17T13:53:15-05:00'
        'note': 'This is an example symptom'
        'user':
          'id': 101
          'first_name': 'Test'
          'last_name': 'User'
    ]
    'resolutions': []
    'additional_values': {}
    'total_time_spent': 0
    'incidents': []
    'changes': []
    'releases': []
    'problems': []

comment =
  'comment':
    'id': 1
    'created_at': '2012-10-17T13:53:15-05:00'
    'note': 'This is an example comment'
    'user':
      'id': 101
      'first_name': 'Test'
      'last_name': 'User'

problem =
  'problem':
    'id': 1

#nock("https://deskapi.gotoassist.com")
#  .persist()
#  .get("/v1/incidents/1.json")
#  .reply(200, JSON.stringify(incident));

module.exports =
  enums:
    api_key: 'aabbccddeeffgghhiijjkk'
    api_host: 'https://deskapi.gotoassist.com'

  incidents: [ openIncident, closedIncident ]

  successfulResponse:
    version: '1.0'
    status: 'Success'
    result: openIncident

  successfulResponseWithOpenIncident:
    version: '1.0'
    status: 'Success'
    result: openIncident

  successfulResponseWithClosedIncident:
    version: '1.0'
    status: 'Success'
    result: closedIncident

  successfulResponseWithComment:
    version: '1.0'
    status: 'Success'
    result: comment

  successfulResponseWithProblem:
    version: '1.0'
    status: 'Success'
    result: problem

  successfulResponseWithProblems:
    version: '1.0'
    status: 'Success'
    result: [ problem, problem ]

  comment: comment
  openIncident: openIncident
  closedIncident: closedIncident
