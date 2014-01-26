class PrismApp.Player extends PrismApp.Renderable

	texture: PIXI.Texture.fromImage("images/player_red.png")

	constructor: (anchorX, anchorY, posX, posY, rotation, active = false) ->
		anchor = {x: anchorX, y: anchorY}
		position = {x: posX, y: posY}
		super(@texture, anchor, position)
		@points = 0
		@velocity = 0
		@moveV = new PIXI.Point(0,0)
		@bindKeys('W', 'S', 'A', 'D') if active
		@isGhost = false
		@rotation = rotation

	bindEvents: ->
		PrismApp.Socket.on 'user:move:up', (data) =>
			@moveUp() if data.id == @id
		PrismApp.Socket.on 'user:move:down', (data) =>
			@moveDown() if data.id == @id
		PrismApp.Socket.on 'user:move:left', (data) =>
			@moveLeft() if data.id == @id
		PrismApp.Socket.on 'user:move:right', (data) =>
			@moveRight() if data.id == @id

	bindKeys: (up, down, left, right) ->
		kd[up].down =>
			@moveUp()
			PrismApp.Socket.emit 'user:move:up', @toJSON()

		kd[down].down =>
			@moveDown()
			PrismApp.Socket.emit 'user:move:down', @toJSON()

		kd[left].down =>
			@moveLeft()
			PrismApp.Socket.emit 'user:move:left', @toJSON()

		kd[right].down =>
			@moveRight()
			PrismApp.Socket.emit 'user:move:right', @toJSON()

	moveUp: ->
		@velocity += 0.1 if @velocity < globals.MAX_VEL

	moveDown: ->
		if @velocity > 0
      @velocity -= 1
    else if @velocity > -globals.MAX_VEL
      @velocity -= 0.05

	moveLeft: ->
		@rotation -= 0.1

	moveRight: ->
		@rotation += 0.1

	toJSON: ->
		id: @id
		anchor: @anchor
		position: @position
		velocity: @velocity
		rotation: @rotation
		moveV: @moveV
