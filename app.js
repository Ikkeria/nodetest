var fs = require('fs');
var options = {
};
 
require('http2').createServer(options, function(request, response) {
  response.end('Welcome HTTP/2.0');
  console.log("Server listening on: http://localhost:8000");
}).listen(8000);