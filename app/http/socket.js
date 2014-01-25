var routes = require('../routes/routes');

module.exports = {
  init: function(server) {
    var io = require('socket.io').listen(server);

    io.configure(function () {
      io.set('log level', 1);
    });

    io.sockets.on('connection', function (socket) {
      socket.on('hello!', routes.user.helloHandler);
    });
  },
}
