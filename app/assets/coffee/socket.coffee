class PrismApp.Socket
  constructor: ->
    @conn = io.connect("http://localhost:3000")

  emit: (event, data) ->
    @conn.emit('hello!', {my: 'data'})

  on: (event, cb) ->
    @conn.on(event, cb)
