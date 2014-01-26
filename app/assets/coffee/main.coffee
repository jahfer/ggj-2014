window.globals =
	WIN_W: 1000
	WIN_H: 700
	NUM_STARS: 50
	MAX_VEL: 10
	FRAMECOUNT: 0

class PrismApp.Main
	constructor: ->
		assetsToLoader = (["images/prism_sprites.json","images/anim/spawn.json","images/anim/world-spawn.json","images/anim/death.json"])

		#assetsToLoader = (["images/prism_sprites.json"])
		loader = new PIXI.AssetLoader(assetsToLoader)
		loader.onComplete = =>
			PrismApp.Assets.onAssetsLoaded()
			@init()

		loader.load()

	init: ->
		PrismApp.Socket.connect()
		@bindEvents()

		count = 0

		@stage = new PIXI.Stage(0x000000)
		@world = new PIXI.DisplayObjectContainer()
		@obstacles = new PIXI.DisplayObjectContainer()
		@otherPlayers = new PIXI.DisplayObjectContainer()

		playerPosition = PrismApp.SpawnPoints.randomFor('player')
		@player = new PrismApp.Player(playerPosition.x, playerPosition.y, playerPosition.rot, 'red', true)

		@textSample = new PIXI.Text("points "+@player.points, {font: "15px Arial", fill: "white", align: "left"})
		@textSample.position.x = 120
		@textSample.position.y = 20

		@renderer = PIXI.autoDetectRenderer(globals.WIN_W,globals.WIN_H)

		$('body').append(@renderer.view)
		prismPosition = PrismApp.SpawnPoints.randomFor('prism')
		@prism = new PrismApp.Prism(prismPosition.x, prismPosition.y)

		for i in [0..3]
			obj = PrismApp.SpawnPoints.smallObject[i]
			obstacle = new PrismApp.Obstacle(0.5,0.5, obj.x, obj.y, obj.rot,'small')
			@obstacles.addChild(obstacle)

		for i in [0..4]
			obj = PrismApp.SpawnPoints.mediumObject[i]
			obstacle = new PrismApp.Obstacle(0.5,0.5, obj.x, obj.y, obj.rot,'medium')
			@obstacles.addChild(obstacle)

		for i in [0..3]
			obj = PrismApp.SpawnPoints.largeObject[i]
			obstacle = new PrismApp.Obstacle(0.5,0.5, obj.x, obj.y, obj.rot,'large')
			@obstacles.addChild(obstacle)

		@world.addChild(@obstacles)
		@world.addChild(@player)
		@world.addChild(@otherPlayers)
		@world.addChild(@prism)

		@stage.addChild(@world)
		@stage.addChild(@textSample)

		@minBound = new PIXI.Point(0,0)
		@maxBound = new PIXI.Point(0,0)

		@stage.addChild(PrismApp.Assets.spawnClips[0])

	bindEvents: ->
		PrismApp.Socket.on 'user:register', (data) =>
			@player.id = data.id

			for id, player of data.players
				console.log "Initialized existing user #{id}"
				newPlayer = new PrismApp.Player(player.position.x, player.position.y, player.rotation, 'yellow')
				newPlayer.id = id
				@otherPlayers.addChild(newPlayer)

			PrismApp.Socket.emit 'user:registered', @player.toJSON()
			requestAnimFrame(@draw)

		PrismApp.Socket.on 'user:new', (player) =>
			console.log "User #{player.id} connected"
			newPlayer = new PrismApp.Player(player.position.x, player.position.y, player.rotation, 'yellow')
			newPlayer.id = player.id
			@otherPlayers.addChild(newPlayer)

		PrismApp.Socket.on 'user:disconnect', (id) =>
			console.log "User #{id} disconnected"
			disconnectedPlayer = @otherPlayers.children.filter (player) -> id == player.id
			@otherPlayers.removeChild(disconnectedPlayer[0])

	updatePlayers: ->
		@updatePlayer(player) for player in @otherPlayers.children
		@updatePlayer(@player)

	initCollision: ->
		@isColliding = true
		setTimeout (=> @isColliding = false), 20

	updatePlayer: (player) ->
		hasCollided = false
		player.move()

		if !hasCollided && !@isColliding
			obstacle = PrismApp.Collisions.oneToManyCollisionCheck(player, @obstacles.children)
			if obstacle?
				hasCollided = true

				# player to the right of obstacle
				if player.position.x > obstacle.position.x + obstacle.width/2
					player.rotation *= -(Math.PI / 4)
					@initCollision()
				# player to the left of obstacle
				else if player.position.x < obstacle.position.x - obstacle.width/2
					player.rotation *= -(Math.PI / 4)
					@initCollision()
				# player below obstacle
				else if player.position.y > obstacle.position.y + obstacle.height/2
					player.rotation *= -(Math.PI / 4)
					@initCollision()
				# player above obstacle
				if player.position.y < obstacle.position.y - obstacle.height/2
					player.rotation *= -(Math.PI / 4)
					@initCollision()

			prism = PrismApp.Collisions.oneToOneCollisionCheck(player, @prism)
			if prism?
				hasCollided = true
				@prism.move()
				@player.points += 10
				@textSample.setText("Points "+@player.points)
				@player.isGhost = true;
				@player.toGhost()
				@otherPlayers.children.forEach (player) -> player.isGhost = false
				console.log("collision with prism!")

			playerHit = PrismApp.Collisions.oneToManyCollisionCheck(player, @otherPlayers.children)
			if playerHit? && @player.isGhost == true
				console.log("you hit a ghost")
			else if playerHit?
				console.log("you hit")

	allPlayers: -> [@player].concat(@otherPlayers.children)

	getNewCenter: ->
		center = new PIXI.Point(0,0)

		allPlayers = @allPlayers()
		for player in allPlayers
			center.x += player.position.x
			center.y += player.position.y

		center.x = center.x / allPlayers.length
		center.y = center.y / allPlayers.length
		return center

	scaleMap: (center) ->
		cx = (globals.WIN_W/2) + Math.abs(center.x) * @world.scale.x
		cy = (globals.WIN_H/2) + Math.abs(center.y) * @world.scale.y
		scale = .8

		allPlayers = @allPlayers()

		for player in allPlayers
			absx = Math.abs(player.position.x) + 100
			absy = Math.abs(player.position.y) + 100

			if absy > cy
				scale = Math.min(scale, cy/absy)
			else if absx > cx
				scale = Math.min(scale, cx/absx)

		@world.scale.x = scale
		@world.scale.y = scale
		@world.position.x = (globals.WIN_W / 2) - center.x * scale
		@world.position.y = (globals.WIN_H / 2) - center.y * scale

		@maxBound.x = center.x + (globals.WIN_W / 2) / scale
		@maxBound.y = center.y + (globals.WIN_H / 2) / scale
		@minBound.x = center.x - (globals.WIN_W / 2) / scale
		@minBound.y = center.y - (globals.WIN_H / 2) / scale

	draw: =>
		PrismApp.stats.begin()
		kd.tick()

		@updatePlayers()
		@scaleMap(@getNewCenter())

		requestAnimFrame @draw
		@renderer.render(@stage)

		PrismApp.stats.end()
		false

$ ->
	window.app = new PrismApp.Main()

