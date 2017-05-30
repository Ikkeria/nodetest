var https = require('http2');
var fs = require('fs');

var options = {
    key: fs.readFileSync(__dirname + '/key.pem'),
    cert: fs.readFileSync(__dirname + '/cert.pem'),
    passphrase: 'testtest1234'
};

require('http2').createServer(options, function(request, response) {
  response.end('Hellold! From HTTP2.');
}).listen(8080);