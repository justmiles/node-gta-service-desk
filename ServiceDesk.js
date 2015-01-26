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

ServiceDesk.prototype.setApiURL = function(apiURL) {
    this.apiURL = apiURL;
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

ServiceDesk.prototype.createIncident = function(payload, callback) {
    payload = { incident : payload  };
    this.XHR('POST','/incidents.'+this.format, null, payload, function(body) {
        callback(body);
    })
};

ServiceDesk.prototype.updateIncident = function(params, payload, callback) {
    payload = { incident : payload  };
    this.XHR('PUT','/incidents.'+this.format, null, payload, function(body) {
        callback(body);
    })
};

// XHR
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
            try {
                var jsonResponse = JSON.parse(response);
            } catch(e) {
                console.log('Could not parse response. ' + e);
                return false;
            }
            if (res.headers.status != '200 OK') {
                console.log(res.headers.status);
            }
            if (jsonResponse.status == 'Success'){
                callback(jsonResponse.result);
            } else {
                console.log('Request failed');
                console.log(jsonResponse.errors[0].error);
                return false;
            }

        });

    });

    req.on('error', function(e) {
        console.log('HTTPS ERROR: ' + e);
    });

    req.write(payloadString);
    req.end();


};

// Utilities
Object.prototype.toURL = function() {
    obj = this;
    return '?' + Object.keys(obj).map(function(k) {
            return encodeURIComponent(k) + '=' + encodeURIComponent(obj[k])
        }).join('&')
};

module.exports = new ServiceDesk();
