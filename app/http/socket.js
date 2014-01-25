var routes = require('../routes/router');

var next_id = 1;

module.exports = {
  init: function(server) {
    var io = require('socket.io').listen(server);

    io.configure(function () {
      io.set('log level', 1);
    });

    io.sockets.on('connection', function (socket) {
      console.log("Connection received")
      socket.emit('user:register', next_id++)

      socket.on('hello!', routes.user.helloHandler);
    });
  },
}
