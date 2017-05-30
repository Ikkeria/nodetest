var https = require('http2');
var fs = require('fs');

var options = {
    key: fs.readFileSync(__dirname + '/key.pem'),
    cert: fs.readFileSync(__dirname + '/cert.pem'),
    passphrase: 'testtest1234'
};
const port = 8080;

try {
  console.log(`starting server on port: ${port}`);

  require('http2').createServer(options, function(request, response) {
    console.log('http/2 request received');
    response.end('Hellold! From HTTP2.');
  }).listen(port);

} catch (error) {
  console.log(`application exploded: ${error}`);
}
