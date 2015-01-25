# node-gta-service-desk
Javascript library for GotoAssist Service Desk




Example:


```javascript
var serviceDesk = new ServiceDesk();
serviceDesk.setApiKey('API_KEY');

serviceDesk.showIncident(100, function(response) {
    console.log(response.result.incident.id);
});
```