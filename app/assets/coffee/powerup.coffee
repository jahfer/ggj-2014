class PrismApp.Powerup extends PrismApp.Renderable

  constructor: (posX, posY, type) ->
    anchor = {x: 0.5, y: 0.5}
    position = {x: posX, y: posY}
    super(PrismApp.Assets.powerupTextureFromType(type), anchor, position)
    @spawnTime = 0
    @type = type

  toJSON: ->
    id: @id
    type: @type
