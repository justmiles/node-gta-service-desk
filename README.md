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

###Create a internal watchlist for an incident
```javascript
var ServiceDesk = require('gta-service-desk');

serviceDesk = new ServiceDesk('API_KEY');

var watch = {
    watched_by: GTA_USER_ID
}

serviceDesk.createIncidentWatch(100, watch, function (res) {
    console.log( "Successfully created watch #" + res.watch.id )
});
```

###Create an external watchlist for an incident
```javascript
var ServiceDesk = require('gta-service-desk');

serviceDesk = new ServiceDesk('API_KEY');

var watch = {
    watched_by: INCREMENT,
    external_email: EMAIL
}

serviceDesk.createIncidentWatch(100, watch, function (res) {
    console.log( "Successfully created watch #" + res.watch.id )
});
```
The INCREMENT is needed because `watched_by` is a mandatory POST parameter. If you need to create multiple external watchlists for a same incident, INCREMENT must be different for each of them. 

If you want to notify the people in the watchlists (external and internal), you must update the incident with the POST parameter `notify_watchlisted` set to true after the creation of the said watchlists.


View http://support.citrixonline.com/s/G2ASD/Help/APIDocs for API documentation.