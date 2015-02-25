# GTA Service Desk
Node.js client for GotoAssist Service Desk

Example:

```javascript
var ServiceDesk = require('node-gta-service-desk');

serviceDesk = new ServiceDesk('API_KEY');

// Shows incident 100 and logs title
serviceDesk.showIncident(100, function (incident) {
    console.log(incident.title);
});

```

API Token can be obtained here:
https://desk.gotoassist.com/my_api_token

View http://support.citrixonline.com/s/G2ASD/Help/APIDocs for API documentation.