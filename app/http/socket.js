var routes = require('../routes/router');
var playerController = require('../controllers/player');
var spawnPoints = require('../helpers/spawn_points');

var powerups = {};

module.exports = {
  init: function(server) {
    var io = require('socket.io').listen(server);

    var newPowerup = function() {
      powerup = spawnPoints.nextPowerup()
      powerups[powerup.id] = powerup
      io.sockets.emit('powerup:new', powerup);
    }

    for (var i=0; i<11; i++) newPowerup();

    io.configure(function () {
      io.set('log level', 1);
    });

    io.sockets.on('connection', function (socket) {
      console.log("====================================")
      console.log("Connection received")

      playerController.register(socket, powerups)

      socket.on('powerup:collected', function(powerup) {
        powerups.splice(powerup.id, 1);
        setTimeout(newPowerup, 1000);
      });
    });
  },
}
