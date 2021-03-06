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
		color: @color
		isGhost: @isGhost

	fromJSON: (data) ->
		@id = data.id
		@anchor = data.anchor
		@position = data.position
		@velocity = data.velocity
		@rotation = data.rotation
		@moveV = data.moveV
		@color = data.color
		@isGhost = data.isGhost

	toGhost: ->
		@isGhost = true
		@visible = false
		@setTexture(PrismApp.Assets.ghostTextureFromColor(@color))
		@anchor.y = 0.8
		@timer()

		ghostAnim = PrismApp.Assets.ghostFromPlayer(@color)
		ghostAnim.visible = true
		ghostAnim.position = @position
		ghostAnim.rotation = @rotation
		ghostAnim.onComplete = =>
			@visible = true
			ghostAnim.visible = false
		ghostAnim.play()

	toRegular: ->
		@isGhost = false
		@reloadTexture()
		@anchor.y = 0.5

	toHitState: ->
		@visible = false
		deathAnim = PrismApp.Assets.death(@color)
		deathAnim.visible = true
		deathAnim.position = @position
		deathAnim.rotation = @rotation
		deathAnim.onComplete = =>
			playerPosition = PrismApp.SpawnPoints.randomFor('player')
			@position.x = playerPosition.x
			@position.y = playerPosition.y
			@visible = true
			deathAnim.visible = false
		deathAnim.gotoAndPlay(0)

	timer: ->
		console.log("timer called")

	applyPowerup: (type) ->
		if type == "shield"
			@shield = true
		else if type == "invisible"
			@visible = false
		else if type == "slow"
			@velocity = 0
		else if type == "fast"
			@velocity = globals.MAX_VEL

		@setTexture(PrismApp.Assets.powerupFromPlayer(type, @color))


