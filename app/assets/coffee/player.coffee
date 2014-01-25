class PrismApp.Player extends PrismApp.Renderable

	texture: PIXI.Texture.fromImage("images/player_red.png")

	constructor: (anchor, position) ->
		super(@texture, anchor, position)

		@velocity = 0
		@moveV = new PIXI.Point(0,0)
		@owner
		@position = 0
		@scale.x = 0.2 + Math.random()*0.8
		@scale.y = @scale.x
		@velocity = MAX_VEL / 20;