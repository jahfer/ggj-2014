var colors = require('../helpers/colors');

var nextId = 1;
var allPlayers = {};

module.exports = {
  register: function(socket, powerups) {
    payload = {id: socket.id, color: colors.nextColor(), powerups: powerups, players: allPlayers}
    socket.emit('user:register', payload)

    socket.on('user:registered', function(data) {
      allPlayers[data.id] = data;
      socket.broadcast.emit('user:new', data);
    });

    socket.on('powerup:collected', function(powerup) {
      powerups.splice(powerup.id, 1);
      setTimeout(newPowerup, 1000);
    });

    eventsToRelay = ['user:ghost:on', 'user:move:up', 'user:move:down', 'user:move:left', 'user:move:right'];

    eventsToRelay.forEach(function(evt) {
      socket.on(evt, function(data) {
        allPlayers[data.id] = data;
        socket.broadcast.emit(evt, data);
      });
    });

    socket.on('user:collect:powerup', function(powerup) {
      console.log("User collected powerup: " + powerup.id)
      socket.broadcast.emit('user:collect:powerup', {id: socket.id, powerup_id: powerup.id, type: powerup.type})
    });

    socket.on('disconnect', function() {
      delete allPlayers[socket.id];
      socket.broadcast.emit('user:disconnect', socket.id);
    });
  }
}
