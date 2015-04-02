# GTA Service Desk

Node.js client for GotoAssist Service Desk

## Installation

If you have the node package manager, npm, installed:

```shell
npm install --save gta-service-desk
```

## Getting Started

API Token can be obtained here: https://desk.gotoassist.com/my_api_token

###Show an incident
```javascript
var ServiceDesk = require('gta-service-desk');

serviceDesk = new ServiceDesk('API_KEY');

// Shows incident 100 and logs title
serviceDesk.showIncident(100, function (res) {
    console.log(res.incident.title);
});
```

###Create an incident
```javascript
var ServiceDesk = require('gta-service-desk');

serviceDesk = new ServiceDesk('API_KEY');

var incident = {
    title: "This is a test",
    service_id: "0000000000",
    assigned_user_id: "0000000000"
}

serviceDesk.createIncident(incident, function(res) {
    console.log( "Successfully created Incident #" + res.incident.id )
});

```

###Update an incident
```javascript
var ServiceDesk = require('gta-service-desk');

serviceDesk = new ServiceDesk('API_KEY');

serviceDesk.showIncident(100, function (res) {

    if (res) {
        var incident = res.incident;
        incident.title = "Updating the title";
        serviceDesk.updateIncident(incident.id, incident, function(res) {
            console.log(res.incident.title); // prints "Updating the title"
        });
    }

});
```

View http://support.citrixonline.com/s/G2ASD/Help/APIDocs for API documentation.