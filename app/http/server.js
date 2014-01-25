var express = require('express')
, http = require('http')
, socket = require('./socket')
, path = require('path');

var app = express();

app.configure(function() {
  app.use(express.static(path.resolve('app/assets')));
})

app.get('/', function(req, res) {
  res.sendfile(path.resolve("app/index.html"));
});

module.exports = {
  listen: function(port) {
    var server = app.listen(port);
    socket.init(server);

    console.log('Express server listening on port', port);
  }
}

