var ServiceDesk = require('../index.js');

var problem = {
    title: 'TEST',
    service_id:'4278204307'
};

serviceDesk = new ServiceDesk('api_key');

exports['ServiceDesk Instantiated'] = function(beforeExit, assert) {
    assert.isNotNull(ServiceDesk);
};