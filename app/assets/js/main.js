$(function() {
  var canvas = document.getElementById("draw");
  var socket = io.connect("http://localhost:3000");

  socket.emit('hello!', {my: 'data'});
});
