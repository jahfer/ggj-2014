window.globals =
	WIN_W: 1000
	WIN_H: 700
	NUM_STARS: 50
	MAX_VEL: 10
	FRAMECOUNT: 0

class PrismApp.Main
	constructor: ->
		assetsToLoader = (["images/anim/prism_sprites.json","images/anim/player-powerups.json","images/anim/spawn.json","images/anim/world-spawn.json","images/anim/death-1.json","images/anim/death-2.json","images/anim/death-3.json","images/anim/death-4.json","images/anim/death-5.json","images/anim/death-6.json","images/anim/fade-player.json","images/anim/ghost-player.json","images/anim/player-ghost.json"])
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
		background = new PIXI.Sprite(PIXI.Texture.fromImage("images/map.jpg"))
		@world = new PIXI.DisplayObjectContainer()
		@obstacles = new PIXI.DisplayObjectContainer()
		@otherPlayers = new PIXI.DisplayObjectContainer()
		@powerups = new PIXI.DisplayObjectContainer()
		@world.addChild(background)

		playerPosition = PrismApp.SpawnPoints.randomFor('player')
		@player = new PrismApp.Player(playerPosition.x, playerPosition.y, playerPosition.rot, 'red', true)
		@player.visible = false
		@textSample = new PIXI.Text("Points " + @player.points, {font: "15px Arial", fill: "white", align: "left"})
		@textSample.position.x = 120
		@textSample.position.y = 20

		@renderer = PIXI.autoDetectRenderer(globals.WIN_W,globals.WIN_H)

		$('body').append(@renderer.view)

		for i in [0..3]
			obj = PrismApp.SpawnPoints.smallObject[i]
			obstacle = new PrismApp.Obstacle(0.5,0.5, obj.x, obj.y, obj.rot,'small')
			@obstacles.addChild(obstacle)
		for i in [0..4]
			obj = PrismApp.SpawnPoints.mediumObject[i]
			obstacle = new PrismApp.Obstacle(0.5,0.5, obj.x, obj.y, obj.rot,'medium')
			@obstacles.addChild(obstacle)
		for i in [0..7]
			obj = PrismApp.SpawnPoints.largeObject[i]
			obstacle = new PrismApp.Obstacle(0.5,0.5, obj.x, obj.y, obj.rot,'large')
			@obstacles.addChild(obstacle)

		@world.addChild(@obstacles)
		@world.addChild(@player)
		@world.addChild(@otherPlayers)

		@world.addChild(@powerups)
		@world.addChild(PrismApp.Assets.spawns)
		@world.addChild(PrismApp.Assets.playerGhosts)
		@world.addChild(PrismApp.Assets.prismClip)
		@world.addChild(PrismApp.Assets.ghostPlayers)
		@world.addChild(PrismApp.Assets.fadePlayers)
		@world.addChild(PrismApp.Assets.deaths)

		@stage.addChild(@world)
		@stage.addChild(@textSample)

		@minBound = new PIXI.Point(0,0)
		@maxBound = new PIXI.Point(0,0)

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

			console.log("Prism Position on init", data.prism)
			@prism = new PrismApp.Prism(data.prism.x, data.prism.y)
			@world.addChild(@prism)

			@player.reloadTexture()

			for id, player of data.players
				console.log "Initialized existing user #{id}"
				newPlayer = new PrismApp.Player(player.position.x, player.position.y, player.rotation, player.color)
				newPlayer.id = id
				@otherPlayers.addChild(newPlayer)

			for id, data of data.powerups
				console.log "Initializing existing powerup #{id}"
				powerup = new PrismApp.Powerup(data.powerup.x, data.powerup.y, data.type)
				powerup.id = id
				@powerups.addChild(powerup)

			PrismApp.Socket.emit 'user:registered', @player.toJSON()
			requestAnimFrame(@draw)

		PrismApp.Socket.on 'powerup:new', (data) =>
			console.log "Powerup #{data.id} added"
			powerup = new PrismApp.Powerup(data.x, data.y, 'fast')
			powerup.id = data.id
			@powerups.addChild(powerup)

		PrismApp.Socket.on 'user:new', (player) =>
			console.log "User #{player.id} connected"
			newPlayer = new PrismApp.Player(player.position.x, player.position.y, player.rotation, player.color)
			newPlayer.id = player.id
			@otherPlayers.addChild(newPlayer)

		PrismApp.Socket.on 'user:disconnect', (id) =>
			console.log "User #{id} disconnected"
			disconnectedPlayer = (@otherPlayers.children.filter (player) -> id == player.id)[0]
			@otherPlayers.removeChild(disconnectedPlayer)

		PrismApp.Socket.on 'user:ghost:on', (player) =>
			console.log "User #{player.id} is the ghost"
			newGhost = (@otherPlayers.children.filter (other) -> player.id == other.id)[0]
			@allPlayers().forEach (other) -> other.toRegular()
			newGhost.toGhost()

		PrismApp.Socket.on 'user:collect:powerup', (data) =>
			player = (@otherPlayers.children.filter (player) -> data.id == player.id)[0]
			player.applyPowerup(data.type)
			powerup = (@powerups.children.filter (powerup) -> data.powerup_id == powerup.id)[0]
			@powerups.removeChild(powerup)

		PrismApp.Socket.on 'prism:new', (position) =>
			console.log("Prism Position for new", position)
			@prism.position.x = position.x
			@prism.position.y = position.y

	updatePlayers: ->
		@updatePlayer(player) for player in @otherPlayers.children
		@updatePlayer(@player)
		@checkCollision(@player)

	initCollision: ->
		@isColliding = true
		setTimeout (=> @isColliding = false), 20

	updatePlayer: (player) ->
		player.move()

	checkCollision: (player) ->
		hasCollided = false
		if !hasCollided && !@isColliding
			if !player.isGhost
				powerup = PrismApp.Collisions.oneToManyCollisionCheck(player, @powerups.children)
				if powerup?
					hasCollided = true
					PrismApp.Socket.emit("user:collect:powerup", powerup.toJSON())
					@player.applyPowerup(powerup.type)
					@player.visible = true
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

				PrismApp.Socket.emit('user:ghost:on', @player.toJSON())
				@player.toGhost()

				@otherPlayers.children.forEach (player) -> player.isGhost = false
				console.log("collision with prism!")

			playerHit = PrismApp.Collisions.oneToManyCollisionCheck(player, @otherPlayers.children)
			if playerHit? && @player.isGhost == true && playerHit.shield == false
				@player.points += 10
				@textSample.setText("Points "+@player.points)
				playerHit.visible = false
				deathAnim = PrismApp.Assets.death(playerHit.color)
				deathAnim.visible = true
				deathAnim.position = playerHit.position
				deathAnim.rotation = playerHit.rotation
				deathAnim.onComplete = =>
					console.log("you killed that guy")
					# @player.visible = true
					deathAnim.visible = false
				deathAnim.gotoAndPlay(0)
				@otherPlayers.removeChild(playerHit)

			else if playerHit? && player.isGhost == true && @player.shield == false
				console.log("you are killed")
			else if playerHit?
				console.log("you hit each other and nothing happens")

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
			absx = Math.abs(player.position.x) + player.width
			absy = Math.abs(player.position.y) + player.height

			if absy > cy
				scale = Math.min(scale, cy/absy)
			if absx > cx
				scale = Math.min(scale, cx/absx)

		@world.scale.x = scale
		@world.scale.y = scale
		@world.position.x = (globals.WIN_W / 2) - center.x * scale
		@world.position.y = (globals.WIN_H / 2) - center.y * scale

		# @maxBound.x = center.x + (globals.WIN_W / 2) / scale
		# @maxBound.y = center.y + (globals.WIN_H / 2) / scale
		# @minBound.x = center.x - (globals.WIN_W / 2) / scale
		# @minBound.y = center.y - (globals.WIN_H / 2) / scale

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

