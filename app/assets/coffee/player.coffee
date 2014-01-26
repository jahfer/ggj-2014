class PrismApp.Player extends PrismApp.Renderable

	constructor: (posX, posY, rotation, color, active = false) ->
		anchor = {x: 0.5, y: 0.5}
		position = {x: posX, y: posY}
		super(PrismApp.Assets.playerTextureFromColor(color), anchor, position)
		@points = 0
		@velocity = 0
		@moveV = new PIXI.Point(0,0)
		@bindKeys('W', 'S', 'A', 'D') if active
		@isGhost = false
		@shield = false
		@color = color
		@rotation = rotation

	reloadTexture: ->
		@setTexture PrismApp.Assets.playerTextureFromColor(@color)

	bindEvents: ->
		PrismApp.Socket.on 'user:move:up', (data) =>
			@fromJSON(data) if data.id == @id
		PrismApp.Socket.on 'user:move:down', (data) =>
			@fromJSON(data) if data.id == @id
		PrismApp.Socket.on 'user:move:left', (data) =>
			@fromJSON(data) if data.id == @id
		PrismApp.Socket.on 'user:move:right', (data) =>
			@fromJSON(data) if data.id == @id

	bindKeys: (up, down, left, right) ->
		kd[up].down =>
			PrismApp.Socket.emit 'user:move:up', @toJSON()
			@moveUp()

		kd[down].down =>
			PrismApp.Socket.emit 'user:move:down', @toJSON()
			@moveDown()

		kd[left].down =>
			PrismApp.Socket.emit 'user:move:left', @toJSON()
			@moveLeft()

		kd[right].down =>
			PrismApp.Socket.emit 'user:move:right', @toJSON()
			@moveRight()

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
		color: @color

	fromJSON: (data) ->
		@id = data.id
		@anchor = data.anchor
		@position = data.position
		@velocity = data.velocity
		@rotation = data.rotation
		@moveV = data.moveV
		@color = data.color

	toGhost: ->
		@setTexture(PrismApp.Assets.ghostTextureFromColor(@color))
		@anchor.y = 0.8
		PrismApp.Socket.emit('user:ghost:on', @toJSON())
		@timer()

	timer: ->
		console.log("timer called")

