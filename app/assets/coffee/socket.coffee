class PrismApp.Socket
  @conn = io.connect("http://localhost:3000")

  @emit: (event, data) ->
    @conn.emit(event, data)

  @on: (event, cb) ->
    @conn.on(event, cb)
