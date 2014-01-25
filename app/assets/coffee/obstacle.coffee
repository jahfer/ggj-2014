class PrismApp.Obstacle extends PrismApp.Renderable

	texture: PIXI.Texture.fromImage("images/obstacle_stationary.png")

	constructor: (anchor, position) ->
		super(@texture, anchor, position)
		
		@moveV = new PIXI.Point(0,0)
		@owner

		# adjust these numbers
		#@position.x = Math.random() * globals.WIN_W - globals.WIN_W/2
		#@position.y = Math.random() * globals.WIN_H - globals.WIN_H/2
		@position.x = Math.floor(Math.random() * (globals.WIN_W - 150 + 1)) + 100;
		@position.y = Math.floor(Math.random() * (globals.WIN_H - 150 + 1)) + 100;

		@scale.x = Math.random() * 0.6 + 0.4
		@scale.y = @scale.x
		@rotation = Math.random() * 2 * Math.PI
		@velocity = globals.MAX_VEL / 50
