class PrismApp.Player extends PrismApp.Renderable

	texture: PIXI.Texture.fromImage("images/player_red.png")

	constructor: (anchorX, anchorY, posX, posY, up, left, down, right) ->
		anchor = {x: anchorX, y: anchorY}
		position = {x: posX, y: posY}
		super(@texture, anchor, position)

		@velocity = 0
		@moveV = new PIXI.Point(0,0)
		@up = up
		@left = left
		@right = right
		@down = down

		kd[@up].down => @velocity += 0.1 if @velocity < globals.MAX_VEL

		kd[@down].down =>
			if @velocity > 0
	      @velocity -= 1
      else if @velocity > -globals.MAX_VEL
        @velocity -= 0.05

		kd[@left].down => @rotation -= 0.1
		kd[@right].down => @rotation += 0.1
