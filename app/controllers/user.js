var nextId = 1;
var allPlayers = {};

module.exports = {
  register: function(socket) {
    payload = {id: socket.id, players: allPlayers}
    socket.emit('user:register', payload)

    console.log("All players:", allPlayers)

    socket.on('user:registered', function(data) {
      allPlayers[data.id] = data;
      socket.broadcast.emit('user:new', data);
    });

    socket.on('user:move:up', function(data) {
      socket.broadcast.emit('user:move:up', data);
    });

    socket.on('disconnect', function() {
      delete allPlayers[socket.id];
      socket.broadcast.emit('user:disconnect', socket.id);
    });
  }
}
