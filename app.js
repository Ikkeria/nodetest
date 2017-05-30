var https = require('http2');
var fs = require('fs');

var options = {
    pfx: fs.readFileSync('server.pfx'),
    passphrase: 'testtest123'
};

require('http2').createServer(options, function(request, response) {
  response.end('Hellold! From HTTP2.');
}).listen(8080);