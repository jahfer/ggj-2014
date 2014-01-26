var colors = require('../helpers/colors')

var nextId = 1;
var allPlayers = {};

module.exports = {
  register: function(socket) {

    payload = {id: socket.id, color: colors.nextColor(), players: allPlayers}
    socket.emit('user:register', payload)

    console.log("All players:", allPlayers)

    socket.on('user:registered', function(data) {
      allPlayers[data.id] = data;
      socket.broadcast.emit('user:new', data);
    });

    eventsToRelay = ['user:move:up', 'user:move:down', 'user:move:left', 'user:move:right'];

    eventsToRelay.forEach(function(evt) {
      socket.on(evt, function(data) {
        socket.broadcast.emit(evt, data);
      })
    });

    socket.on('disconnect', function() {
      delete allPlayers[socket.id];
      socket.broadcast.emit('user:disconnect', socket.id);
    });
  }
}
