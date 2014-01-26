class PrismApp.Socket

  @connect: ->
    @conn = io.connect("http://localhost:5000")

  @emit: (event, data) ->
    @conn.emit(event, data)

  @on: (event, cb) ->
    @conn.on(event, cb)
