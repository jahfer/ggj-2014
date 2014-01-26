window.globals =
	WIN_W: 1000
	WIN_H: 700
	NUM_STARS: 50
	MAX_VEL: 10
	FRAMECOUNT: 0

class PrismApp.Main
	constructor: ->
		assetsToLoader = (["images/anim/prism_sprites.json","images/anim/spawn.json","images/anim/world-spawn.json","images/anim/death.json","images/anim/fade-player.json","images/anim/ghost-player.json","images/anim/player-ghost.json"])
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
		@powerups = new PIXI.DisplayObjectContainer()

		playerPosition = PrismApp.SpawnPoints.randomFor('player')
		@player = new PrismApp.Player(playerPosition.x, playerPosition.y, playerPosition.rot, 'red', true)
		@player.visible = false
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

		for i in [0..3]
			obj = PrismApp.SpawnPoints.randomFor('powerup')
			#PrismApp.SpawnPoints.powerup[]
			powerup = new PrismApp.Powerup(obj.x, obj.y,'fast')
			@powerups.addChild(powerup)

		for i in [3..6]
			obj = PrismApp.SpawnPoints.randomFor('powerup')
			powerup = new PrismApp.Powerup(obj.x, obj.y,'slow')
			@powerups.addChild(powerup)

		for i in [6..9]
			obj = PrismApp.SpawnPoints.randomFor('powerup')
			powerup = new PrismApp.Powerup(obj.x, obj.y,'invisible')
			@powerups.addChild(powerup)

		@world.addChild(@obstacles)
		@world.addChild(@player)
		@world.addChild(@otherPlayers)
		@world.addChild(@prism)
		@world.addChild(@powerups)

		@stage.addChild(@world)
		@stage.addChild(@textSample)

		@minBound = new PIXI.Point(0,0)
		@maxBound = new PIXI.Point(0,0)
		@world.addChild(PrismApp.Assets.spawns)
		@world.addChild(PrismApp.Assets.playerGhosts)
		@world.addChild(PrismApp.Assets.ghostPlayers)
		@world.addChild(PrismApp.Assets.fadePlayers)
		@world.addChild(PrismApp.Assets.deaths)

	bindEvents: ->
		PrismApp.Socket.on 'user:register', (data) =>
			@player.id = data.id
			@player.color = data.color
			spawnAnim = PrismApp.Assets.playerSpawnFromColor(@player.color)
			spawnAnim.position = @player.position
			spawnAnim.rotation = @player.rotation
			spawnAnim.onComplete = =>
				@player.visible = true
				spawnAnim.visible = false
			spawnAnim.play()

			@player.reloadTexture()

			for id, player of data.players
				console.log "Initialized existing user #{id}"
				newPlayer = new PrismApp.Player(player.position.x, player.position.y, player.rotation, player.color)
				newPlayer.id = id
				@otherPlayers.addChild(newPlayer)

			PrismApp.Socket.emit 'user:registered', @player.toJSON()
			requestAnimFrame(@draw)

		PrismApp.Socket.on 'user:new', (player) =>
			console.log "User #{player.id} connected"
			newPlayer = new PrismApp.Player(player.position.x, player.position.y, player.rotation, player.color)
			newPlayer.id = player.id
			@otherPlayers.addChild(newPlayer)

		PrismApp.Socket.on 'user:disconnect', (id) =>
			console.log "User #{id} disconnected"
			disconnectedPlayer = @otherPlayers.children.filter (player) -> id == player.id
			@otherPlayers.removeChild(disconnectedPlayer[0])

		PrismApp.Socket.on 'user:ghost:on', (player) =>
      console.log "User #{player.id} is the ghost"
      newGhost = @otherPlayers.children.filter (player) -> id == player.id
      newGhost[0].toGhost()

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
			powerup = PrismApp.Collisions.oneToManyCollisionCheck(player, @powerups.children)
			if powerup?
				hasCollided = true

				if powerup.type == "shield"
					@player.shield = true
				else if powerup.type == "invisible"
					@player.visible = false
				else if powerup.type == "slow"
					@player.velocity = 0
				else if powerup.type == "fast"
					@player.velocity = globals.MAX_VEL

				@powerups.removeChild(powerup)
				#powerup.visible = false

			obstacle = PrismApp.Collisions.oneToManyCollisionCheck(player, @obstacles.children)
			if obstacle?
				hasCollided = true
				player.rotation *= -(Math.PI / 4)
				@initCollision()

				# # player to the right of obstacle
				# if player.position.x > obstacle.position.x + obstacle.width/2
				# 	player.rotation *= -(Math.PI / 4)
				# 	@initCollision()
				# # player to the left of obstacle
				# else if player.position.x < obstacle.position.x - obstacle.width/2
				# 	player.rotation *= -(Math.PI / 4)
				# 	@initCollision()
				# # player below obstacle
				# else if player.position.y > obstacle.position.y + obstacle.height/2
				# 	player.rotation *= -(Math.PI / 4)
				# 	@initCollision()
				# # player above obstacle
				# else if player.position.y < obstacle.position.y - obstacle.height/2

			prism = PrismApp.Collisions.oneToOneCollisionCheck(player, @prism)
			if prism?
				hasCollided = true
				@prism.move()
				@player.points += 10
				@textSample.setText("Points "+@player.points)
				@player.isGhost = true
				@player.visible = false
				ghostAnim = PrismApp.Assets.ghostFromPlayer(@player.color)
				ghostAnim.position = @player.position
				ghostAnim.rotation = @player.rotation
				ghostAnim.onComplete = =>
					@player.visible = true
					ghostAnim.visible = false
				ghostAnim.play()

				@player.toGhost()
				@otherPlayers.children.forEach (player) -> player.isGhost = false
				console.log("collision with prism!")

			playerHit = PrismApp.Collisions.oneToManyCollisionCheck(player, @otherPlayers.children)
			if playerHit? && @player.isGhost == true && playerHit.shield == false
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

		allPlayers = @allPlayers()

		scale = 1
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

