var routes = require('../routes/router');
var userController = require('../controllers/user');

module.exports = {
  init: function(server) {
    var io = require('socket.io').listen(server);

    io.configure(function () {
      io.set('log level', 1);
    });

    io.sockets.on('connection', function (socket) {
      console.log("====================================")
      console.log("Connection received")

      userController.register(socket)
    });
  },
}
