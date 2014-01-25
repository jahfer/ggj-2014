class PrismApp.Player extends PrismApp.Renderable

	texture: PIXI.Texture.fromImage("images/player_red.png")

	constructor: (anchor, position) ->
		super(@texture, anchor, position)

		@velocity = 0
		@moveV = new PIXI.Point(0,0)
		@owner
		#@position = 0
		#@scale.x = 0.2 + Math.random()*0.8
		#@scale.y = @scale.x
		#@velocity = MAX_VEL / 20;

		kd["UP"].down =>
			if @velocity < globals.MAX_VEL 
				@velocity += 0.1
				
		kd["DOWN"].down =>
			if @velocity > 0
	            @velocity -= 1
	        else if @velocity > -globals.MAX_VEL
	            @velocity -= 0.05
		kd["LEFT"].down =>
			@rotation -= 0.1
		kd["RIGHT"].down =>
			@rotation += 0.1