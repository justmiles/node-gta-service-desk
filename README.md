# node-gta-service-desk
Javascript library for GotoAssist Service Desk

Example:


```javascript
var serviceDesk = require('./ServiceDesk.js');

serviceDesk.setApiKey('API_KEY');

serviceDesk.showIncident(1, function(response) {
    console.log(response.status.incident.title);
});
```

API Token can be obtained here:
https://desk.gotoassist.com/my_api_token

View http://support.citrixonline.com/s/G2ASD/Help/APIDocs for API documentation.