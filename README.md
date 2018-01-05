# GTA Service Desk

> Node.js client for GotoAssist Service Desk

[![Build Status](https://travis-ci.org/justmiles/node-gta-service-desk.svg?branch=master)](https://travis-ci.org/justmiles/node-gta-service-desk)

## Getting Started

If you have the node package manager, npm, installed:

```shell
npm install --save gta-service-desk
```
Obtain your API here: https://desk.gotoassist.com/my_api_token

### Show an incident
```javascript
var ServiceDesk = require('gta-service-desk');

serviceDesk = new ServiceDesk('API_KEY');

// Shows incident 100 and logs title
serviceDesk.getIncident(100, function (err, res) {
    console.log(res.incident.title);
});
```

### Create an incident
```javascript
var ServiceDesk = require('gta-service-desk');

serviceDesk = new ServiceDesk('API_KEY');

var incident = {
    title: "This is a test",
    service_id: "0000000000",
    assigned_user_id: "0000000000"
}

serviceDesk.createIncident(incident, function(err, res) {
    console.log( "Successfully created Incident #" + res.incident.id )
});

```

### Update an incident
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

### Create a internal watchlist for an incident
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

### Create an external watchlist for an incident
```javascript
var ServiceDesk = require('gta-service-desk');

serviceDesk = new ServiceDesk('API_KEY');

var watch = {
    external_email: EMAIL
}

serviceDesk.createIncidentWatch(100, watch, function (res) {
    console.log( "Successfully created watch #" + res.watch.id )
});
```

If you want to notify the people in the watchlists (external and internal), you must update the incident with the POST parameter `notify_watchlisted` set to true after the creation of the said watchlists.


View http://support.citrixonline.com/s/G2ASD/Help/APIDocs for API documentation.
