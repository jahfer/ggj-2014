var server = require('./http/server')
var port = process.env.PORT || 3000;

server.listen(port);
