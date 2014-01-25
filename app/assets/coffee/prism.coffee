class PrismApp.Prism extends PrismApp.Renderable

	texture: PIXI.Texture.fromImage("images/prism.png")

	constructor: (anchorX, anchorY, posX, posY) ->
		anchor = {x: anchorX, y: anchorY}
		position = {x: posX, y: posY}
		super(@texture, anchor, position)

		@velocity = 0
		@moveV = new PIXI.Point(0,0)
		@owner



