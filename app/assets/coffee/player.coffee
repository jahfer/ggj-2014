class PrismApp.Player extends PrismApp.Renderable

	texture: PIXI.Texture.fromImage("images/player_red.png")

	constructor: (anchor, position, up, left, down, right) ->
		super(@texture, anchor, position)

		@velocity = 0
		@moveV = new PIXI.Point(0,0)
		@owner
		@up = up
		@left = left
		@right = right
		@down = down
		#@position = 0
		#@scale.x = 0.2 + Math.random()*0.8
		#@scale.y = @scale.x
		#@velocity = MAX_VEL / 20;

		kd[@up].down =>
			if @velocity < globals.MAX_VEL 
				@velocity += 0.1

		kd[@down].down =>
			if @velocity > 0
	            @velocity -= 1
	        else if @velocity > -globals.MAX_VEL
	            @velocity -= 0.05

		kd[@left].down =>
			@rotation -= 0.1

		kd[@right].down =>
			@rotation += 0.1