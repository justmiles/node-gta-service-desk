# GTA Service Desk

Node.js client for GotoAssist Service Desk

## Installation

If you have the node package manager, npm, installed:

```shell
npm install --save gta-service-desk
```

## Getting Started

API Token can be obtained here: https://desk.gotoassist.com/my_api_token

Example:

```javascript
var ServiceDesk = require('gta-service-desk');

serviceDesk = new ServiceDesk('API_KEY');

// Shows incident 100 and logs title
serviceDesk.showIncident(100, function (res) {
    console.log(res.incident.title);
});

```

View http://support.citrixonline.com/s/G2ASD/Help/APIDocs for API documentation.