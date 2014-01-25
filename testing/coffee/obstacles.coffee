class PrismApp.Obstacles extends PrismApp.Renderable

	texture: PIXI.Texture.fromImage("images/prism.png")

	constructor: (anchor, position) ->
		super(@texture, anchor, position)
		
		@velocity = 0
		@moveV = new PIXI.Point(0,0)
		@owner


