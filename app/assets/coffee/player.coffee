class PrismApp.Player extends PrismApp.Renderable

	texture: PIXI.Texture.fromImage("images/player_red.png")

	constructor: (anchorX, anchorY, posX, posY, active = false) ->
		anchor = {x: anchorX, y: anchorY}
		position = {x: posX, y: posY}
		super(@texture, anchor, position)

		@velocity = 0
		@moveV = new PIXI.Point(0,0)
		@bindKeys('W', 'S', 'A', 'D') if active

	bindKeys: (up, down, left, right) ->
		kd[up].down =>
			@velocity += 0.1 if @velocity < globals.MAX_VEL

		kd[down].down =>
			if @velocity > 0
			    @velocity -= 1
		    else if @velocity > -globals.MAX_VEL
		        @velocity -= 0.05

		kd[left].down => @rotation -= 0.1
		kd[right].down => @rotation += 0.1

	toJSON: ->
		id: @id
		anchor: @anchor
		position: @position
		velocity: @velocity
		rotation: @rotation
		moveV: @moveV
