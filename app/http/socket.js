var routes = require('../routes/router');
var playerController = require('../controllers/player');
var spawnPoints = require('../helpers/spawn_points');

var powerups = {};
var prism;

module.exports = {
  init: function(server) {
    var io = require('socket.io').listen(server);

    var newPowerup = function() {
      powerup = spawnPoints.nextPowerup();
      powerups[powerup.id] = powerup;
      io.sockets.emit('powerup:new', powerup);
    }

    var newPrism = function() {
      prism = spawnPoints.randomFor('prism')
      io.sockets.emit('prism:new', prism)
    }

    for (var i=0; i<11; i++) newPowerup();
    newPrism();

    console.log("Prism position:", prism)

    io.configure(function () {
      io.set('log level', 1);
    });

    io.sockets.on('connection', function (socket) {
      console.log("====================================")
      console.log("Connection received")

      playerController.register(socket, powerups, prism)

      socket.on('user:ghost:on', newPrism)

      socket.on('user:collect:powerup', function(powerup) {
        delete powerups[powerup.id];
        spawnPoints.removePowerup(powerup.id);
        setTimeout(newPowerup, 1000);
      });
    });
  },
}
