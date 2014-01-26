class PrismApp.Socket

  @connect: ->
    @conn = io.connect("http://prismapp.herokuapp.com")

  @emit: (event, data) ->
    @conn.emit(event, data)

  @on: (event, cb) ->
    @conn.on(event, cb)
