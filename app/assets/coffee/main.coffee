window.globals =
	WIN_W: 1000
	WIN_H: 700
	NUM_STARS: 50
	MAX_VEL: 10
	FRAMECOUNT: 0

class PrismApp.Main
	constructor: ->
		@playerTextures = []
		@ghostTextures = []
		@obstacleTextures = []
		@spawnTextures1 = []
		@spawnTextures2 = []
		@spawnTextures3 = []
		@spawnTextures4 = []
		@spawnTextures5 = []
		@spawnTextures6 = []
		playerRespondPoints = [{x:85, y:85, rot:Math.PI/2},{x:85, y:480, rot:Math.PI/2},{x:85, y:860, rot:Math.PI/2},{x:85, y:1245, rot:Math.PI/2},{x:85, y:1640, rot:Math.PI/2},{x:85, y:2025, rot:Math.PI/2},{x:85, y:2400, rot:Math.PI/2},{x:1060, y:2400, rot:0},{x: 2000, y:2400, rot: 0},{x: 2940, y:2400, rot: 0},{x:3920, y:2400, rot: -Math.PI/2},{x:3920, y:2025, rot: -Math.PI/2},{x:3920, y:1640, rot: -Math.PI/2},{x:3920, y:1245, rot: -Math.PI/2},{x:3920, y:860, rot: -Math.PI/2},{x:3920, y:480, rot: -Math.PI/2},{x:3920, y:85, rot:-Math.PI/2}]
		smallObjectRespondPoints = [{x:570, y:1250, rot:0},{x:380, y:2300, rot:0},{x:3445, y:1250, rot:0},{x:3625, y:2312, rot:0}]
		mediumObjectRespondPoints = [{x:570, y:1732, rot:0},{x:570, y:767, rot:0},{x:2000, y:40, rot:0},{x:3435, y:768, rot:0},{x:3435, y:1733, rot:0}]
		largeObjectRespondPoints = [{x:1142, y:574, rot:Math.PI/4},{x:1142, y:1980, rot:-Math.PI/4},{x:2863, y:1980, rot:-Math.PI/4},{x:2863, y:574, rot:-Math.PI/4}]
		powerupRespondPoints = [{x:817, y:1556, rot:0},{x:817, y:980,rot:0},{x:1014, y:230, rot:0},{x:1749, y:955, rot:0},{x:1749, y:1502, rot:0},{x:2257, y:955, rot:0},{x:2257, y:1502,rot:0},{x:2991, y:231, rot:0},{x:3188, y:981, rot:0},{x:3188, y:1556, rot:0}]
		@prismRespondPoints = [{x: 570, y:381, rot:0},{x: 570, y: 2118, rot:0},{x:951, y:1250, rot:0},{x: 1523, y: 767, rot:0},{x: 1523, y:1732, rot:0},{x: 2000, y:1250, rot:0},{x: 2482, y: 768, rot:0},{x: 2482, y:1733, rot:0},{x: 3435, y: 382, rot:0},{x: 3435, y:2119, rot:0}]
		
		assetsToLoader = (["images/prism_sprites.json","images/anim/spawn.json"])
		#assetsToLoader = (["images/prism_sprites.json"])
		loader = new PIXI.AssetLoader(assetsToLoader)
		loader.onComplete = @onAssetsLoaded
		loader.load()
		
		count = 0

		@stage = new PIXI.Stage(0x000000)
		@world = new PIXI.DisplayObjectContainer()
		@obstacles = new PIXI.DisplayObjectContainer()
		@otherPlayers = new PIXI.DisplayObjectContainer()

		playerPosition = playerRespondPoints[Math.floor(Math.random() * playerRespondPoints.length)]
		@player = new PrismApp.Player(0.5, 0.5, playerPosition.x, playerPosition.y, playerPosition.rot, true)


		@textSample = new PIXI.Text("points "+@player.points, {font: "35px Arial", fill: "white", align: "left"})
		@textSample.position.x = 120
		@textSample.position.y = 120

		@renderer = PIXI.autoDetectRenderer(globals.WIN_W,globals.WIN_H)

		$('body').append(@renderer.view)
		prismPosition = @prismRespondPoints[Math.floor(Math.random() * @prismRespondPoints.length)]
		@prism = new PrismApp.Prism(prismPosition.x, prismPosition.y)


		for i in [1..smallObjectRespondPoints.length]
			position = smallObjectRespondPoints[Math.floor(Math.random() * smallObjectRespondPoints.length)]
			obstacle = new PrismApp.Obstacle(0.5,0.5, position.x, position.y, position.rot)
			@obstacles.addChild(obstacle)

		for i in [1..mediumObjectRespondPoints.length]
			position = mediumObjectRespondPoints[Math.floor(Math.random() * mediumObjectRespondPoints.length)]
			obstacle = new PrismApp.Obstacle(0.5,0.5, position.x, position.Y, position.rot)
			@obstacles.addChild(obstacle)

		for i in [1..largeObjectRespondPoints.length]
			position = largeObjectRespondPoints[Math.floor(Math.random() * largeObjectRespondPoints.length)]
			obstacle = new PrismApp.Obstacle(0.5,0.5, position.x, position.Y, position.rot)
			@obstacles.addChild(obstacle)

		@world.addChild(@obstacles)
		@world.addChild(@player)
		@world.addChild(@otherPlayers)
		@world.addChild(@prism)

		@stage.addChild(@world)
		@stage.addChild(@textSample)

		@minBound = new PIXI.Point(0,0)
		@maxBound = new PIXI.Point(0,0)

		@bindEvents()

	onAssetsLoaded: =>

		for i in [0..2]
			texture = PIXI.Texture.fromFrame ("obstacle_"+(i+1)+".png")
			@obstacleTextures.push(texture)

		for i in [0..5]
			texture = PIXI.Texture.fromFrame ("ghost_"+(i+1)+".png")
			@ghostTextures.push(texture)
			texture = PIXI.Texture.fromFrame ("player_"+(i+1)+".png")
			@playerTextures.push(texture)

		for i in [0..26]
			if i < 10
				texture1 = PIXI.Texture.fromFrame ("spawn-1_00"+(i)+".png")
				texture2 = PIXI.Texture.fromFrame ("spawn-2_00"+(i)+".png")
				texture3 = PIXI.Texture.fromFrame ("spawn-3_00"+(i)+".png")
				texture4 = PIXI.Texture.fromFrame ("spawn-4_00"+(i)+".png")
				texture5 = PIXI.Texture.fromFrame ("spawn-5_00"+(i)+".png")
				texture6 = PIXI.Texture.fromFrame ("spawn-6_00"+(i)+".png")
			else
				texture1 = PIXI.Texture.fromFrame ("spawn-1_0"+(i)+".png")
				texture2 = PIXI.Texture.fromFrame ("spawn-2_0"+(i)+".png")
				texture3 = PIXI.Texture.fromFrame ("spawn-3_0"+(i)+".png")
				texture4 = PIXI.Texture.fromFrame ("spawn-4_0"+(i)+".png")
				texture5 = PIXI.Texture.fromFrame ("spawn-5_0"+(i)+".png")
				texture6 = PIXI.Texture.fromFrame ("spawn-6_0"+(i)+".png")
			@spawnTextures1.push(texture1)
			@spawnTextures2.push(texture2)
			@spawnTextures3.push(texture3)
			@spawnTextures4.push(texture4)
			@spawnTextures5.push(texture5)
			@spawnTextures6.push(texture6)
		
		spawn1 = new PIXI.MovieClip(@spawnTextures1)
		spawn1.position.x = 250
		spawn1.position.y = 250
		spawn1.anchor.x = .5
		spawn1.anchor.y = .5
		spawn1.animationSpeed = .5
		spawn1.loop = false
		spawn1.play()

		spawn2 = new PIXI.MovieClip(@spawnTextures2)
		spawn2.position.x = 250
		spawn2.position.y = 250
		spawn2.anchor.x = .5
		spawn2.anchor.y = .5
		spawn2.animationSpeed = .5
		spawn2.loop = false
		spawn2.play()
		spawn3 = new PIXI.MovieClip(@spawnTextures3)
		spawn3.position.x = 350
		spawn3.position.y = 350
		spawn3.anchor.x = .5
		spawn3.anchor.y = .5
		spawn3.animationSpeed = .5
		spawn3.loop = false
		spawn3.play()
		spawn4 = new PIXI.MovieClip(@spawnTextures4)
		spawn4.position.x = 450
		spawn4.position.y = 450
		spawn4.anchor.x = .5
		spawn4.anchor.y = .5
		spawn4.animationSpeed = .5
		spawn4.loop = false
		spawn4.play()
		spawn5 = new PIXI.MovieClip(@spawnTextures5)
		spawn5.position.x = 550
		spawn5.position.y = 550
		spawn5.anchor.x = .5
		spawn5.anchor.y = .5
		spawn5.animationSpeed = .5
		spawn5.loop = false
		spawn5.play()
		spawn6 = new PIXI.MovieClip(@spawnTextures6)
		spawn6.position.x = 660
		spawn6.position.y = 660
		spawn6.anchor.x = .6
		spawn6.anchor.y = .6
		spawn6.animationSpeed = .6
		spawn6.loop = false
		spawn6.play()
		#if i == 26
		#testTexture.stop()
		@stage.addChild(testTexture)	
		# for i in [0..2]
		# 	texture = PIXI.Texture.fromFrame ("obstacle_"+(i+1)+".png")
		# 	@playerTextures.push(texture)


	bindEvents: ->
		PrismApp.Socket.on 'user:register', (data) =>
			@player.id = data.id

			for id, player of data.players
				console.log "Initialized existing user #{id}"
				newPlayer = new PrismApp.Player(0.5, 0.5, player.position.x, player.position.y)
				newPlayer.id = id
				@otherPlayers.addChild(newPlayer)

			PrismApp.Socket.emit 'user:registered', @player.toJSON()
			requestAnimFrame(@draw)

		PrismApp.Socket.on 'user:new', (player) =>
			console.log "User #{player.id} connected"
			newPlayer = new PrismApp.Player(0.5, 0.5, player.position.x, player.position.y)
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
				@player.setTexture(@playerTextures[2])
				@player.points += 10
				@textSample.setText("Points "+@player.points)
				#@player.isGhost = true;
				console.log("collision with prism!")
			
			# playerHit = PrismApp.Collisions.oneToManyCollisionCheck(player, @otherPlayers.children)
			# if playerHit? && @player.isGhost = true
			# 	console.log("you hit a ghost")
			# else if playerHit?
			# 	console.log("you hit")



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
		scale = 1

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

