const http = require('http');
const port = process.env.PORT || 80;

console.log(`creating a request echo server on port ${port}`);

http.createServer((request, response) => {
  const content = `GET ${request.headers['host']}${request.url} (${request.headers['user-agent']})`;
  console.log(content);
  response.writeHead(200, {
    'Content-Type': 'text/plain'
  });
  response.write(content);
  response.end();
}).listen(port);
