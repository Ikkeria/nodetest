/*var http = require('http');
var port = process.env.port || 1337;
http.createServer(function (req, res) {
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.end('Hello World\n');
}).listen(port);*/

'use strict';

let spdy = require('spdy'),
    fs = require('fs');
    
let options = {
    pfx: fs.readFileSync('.\server.pfx'),
    passphrase: 'testtest1234'
};

spdy.createServer(options, function(req, res) {
    res.writeHead(200);
    res.end('Hello world over HTTP/2');
}).listen(3000);