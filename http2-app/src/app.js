const http = require('http2');
const fs = require('fs');
const port = process.env.PORT || 1337;
const options = {
    key: fs.readFileSync(__dirname + '/key.pem'),
    cert: fs.readFileSync(__dirname + '/cert.pem'),
    passphrase: 'testtest1234'
};


console.log(`creating a request echo server on port ${port}`);

http.createServer(options, (request, response) => {
  const content = `GET ${request.headers['host']}${request.url} (${request.headers['user-agent']})`;
  console.log(content);
  response.writeHead(200, {
    'Content-Type': 'text/plain'
  });
  response.write(content);
  response.end();
}).listen(port);
