const protocol = (process.env.PROTOCOL || 'http').toLowerCase();

if (!(protocol === 'http' || protocol === 'https' || protocol === 'http2')) {
  const error = `invalid protocol '${protocol}'`
  throw error;
}

const http = require(protocol);
const fs = require('fs');
const port = process.env.PORT || 1337;
const options = {
  key: fs.readFileSync(__dirname + '/key.pem'),
  cert: fs.readFileSync(__dirname + '/cert.pem'),
  passphrase: 'testtest1234'
}

console.log(`creating a request echo server on port ${port}`);
if (protocol === 'http') {
  http.createServer(worker).listen(port);
} else {
  http.createServer(options, worker).listen(port);
}

function worker(request, response) {
  const content = `(${protocol.toUpperCase()}) GET[:${port}] ${request.headers['host']}${request.url} (${request.headers['user-agent']})`;
  console.log(content);
  response.writeHead(200, {
    'Content-Type': 'text/plain'
  });
  response.write(content);
  response.end();
}