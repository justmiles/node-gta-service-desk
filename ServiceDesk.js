var http = require('https');

var ServiceDesk = function() {

    this.apiKey = '';
    this.apiHost = 'deskapi.gotoassist.com';
    this.apiVersion = 'v1';
    this.format = 'json';

};

ServiceDesk.prototype.setApiKey = function(apiKey) {
    this.apiKey = apiKey;
};

ServiceDesk.prototype.getApiKey = function() {
    return this.apiKey;
};

ServiceDesk.prototype.setApiURL = function(apiURL) {
    this.apiURL = apiURL;
};

ServiceDesk.prototype.getApiURL = function() {
    return this.apiURL;
};

ServiceDesk.prototype.XHR = function(method, api, params, payload, callback) {
    if (params == null) {
        params = '';
    } else {
        params = params.toURL();
    }
    payloadString = JSON.stringify(payload);

    var options = {
        host: this.apiHost,
        path: '/' + this.apiVersion + api + params,
        method: method,
        auth : 'x:' + this.apiKey,
        headers: {
            'Content-Type': 'application/json',
            'Content-Length': payloadString.length
        }
    };

    var req = http.request(options, function (res) {
        res.setEncoding('utf8');

        var response = '';

        res.on('data', function (data) {
            response += data;
        });

        res.on('end', function() {
            if (res.headers.status != '200 OK') {
                console.log(res.headers.status);
            }

            callback(JSON.parse(response));

        });

    });

    req.on('error', function(e) {
        console.log('HTTPS ERROR: ' + e);
    });

    req.write(payloadString);
    req.end();


};

// Incidents
ServiceDesk.prototype.showIncidents = function(params, callback) {

    this.XHR('GET', '/incidents.'+this.format, params, null, function(body) {
        callback(body);
    })

};

ServiceDesk.prototype.showIncident = function(id, callback) {
    this.XHR('GET','/incidents/'+id+'.'+this.format, null, null, function(body) {
        callback(body);
    })
};

ServiceDesk.prototype.createIncident = function(id,params, payload, callback) {
    payload = { incident : payload  };
    this.XHR('POST','/incidents/'+id+'.'+this.format, null, payload, function(body) {
        callback(body);
    })
};

ServiceDesk.prototype.updateIncident = function(params, payload, callback) {
  payload = { incident : payload  };
  this.XHR('PUT','/incidents.'+this.format, null, payload, function(body) {
    callback(body);
  })
};

// Utilities
Object.prototype.toURL = function() {
    obj = this;
    return '?' + Object.keys(obj).map(function(k) {
            return encodeURIComponent(k) + '=' + encodeURIComponent(obj[k])
        }).join('&')
};
