window.globals =
	WIN_W: 1000
	WIN_H: 700
	NUM_STARS: 50
	MAX_VEL: 10
	FRAMECOUNT: 0

class PrismApp.Main
	constructor: ->
		@playerTextures = []

		assetsToLoader = ["images/prism_sprites.json"]
		loader = new PIXI.AssetLoader(assetsToLoader)
		loader.onComplete = @onAssetsLoaded
		loader.load()

		testingPlayers = []

		count = 0

		@stage = new PIXI.Stage(0x000000)
		@world = new PIXI.DisplayObjectContainer()
		@obstacles = new PIXI.DisplayObjectContainer()
		@otherPlayers = new PIXI.DisplayObjectContainer()

		@renderer = PIXI.autoDetectRenderer(globals.WIN_W,globals.WIN_H)

		$('body').append(@renderer.view)

		@otherPlayers.addChild(new PrismApp.Player(0.5, 0.5, 200, 150))
		@otherPlayers.addChild(new PrismApp.Player(0.5, 0.5, 400, 150))
		@prism = new PrismApp.Prism()

		@player = new PrismApp.Player(0.5, 0.5, 0, 0, true)

		for i in [0..10]
			obstacle = new PrismApp.Obstacle({x: 0.5, y: 0.5}, {x: 600, y: 250})
			@obstacles.addChild(obstacle)

		@world.addChild(@obstacles)
		@world.addChild(@player)
		@world.addChild(@otherPlayers)
		@world.addChild(@prism)

		@stage.addChild(@world)

		@minBound = new PIXI.Point(0,0)
		@maxBound = new PIXI.Point(0,0)

		@bindEvents()

	onAssetsLoaded: =>
		for i in [0..17]
			texture = PIXI.Texture.fromFrame ("ghost "+(i+1)+".png")
			@playerTextures.push(texture)
			testTexture = new PIXI.MovieClip(@playerTextures)
			testTexture.position.x = 50;
			testTexture.position.y = 50;
			testTexture.anchor.x = .5;
			testTexture.anchor.y = .5;
			testTexture.animationSpeed = .2
			testTexture.gotoAndPlay(Math.random()*27)
			@stage.addChild(testTexture)

	bindEvents: ->
		PrismApp.Socket.on 'user:register', (id) =>
			@player.id = id
			console.log @player.toJSON()
			# lets kick things off
			requestAnimFrame(@draw)

	updatePlayers: ->
		@updatePlayer(player) for player in @otherPlayers
		@updatePlayer(@player)

	updatePlayer: (player) ->
		hasCollided = false
		player.move()

		if !hasCollided && !@isColliding
			obstacle = @oneToManyCollisionCheck(player, @obstacles.children)
			if obstacle?
				hasCollided = true


				console.log("collision with obstacle!")
				if player.position.x > obstacle.position.x + obstacle.width
					player.rotation *= -Math.PI
					@isColliding = true
					setTimeout (=> @isColliding = false), 50

				else if player.position.y > obstacle.position.y + obstacle.height
					player.rotation *= -Math.PI
					@isColliding = true
					setTimeout (=> @isColliding = false), 50

				else if player.position.x < obstacle.position.x
					player.rotation *= -Math.PI
					@isColliding = true
					setTimeout (=> @isColliding = false), 50

				else if player.position.y < obstacle.position.y
					player.rotation *= -Math.PI
					@isColliding = true
					setTimeout (=> @isColliding = false), 50

			prism = @oneToOneCollisionCheck(player, @prism)
			if prism?
				hasCollided = true
				@prism.move()
				console.log("collision with prism!")

	oneToManyCollisionCheck: (one, many) ->
			for collider in many
				return collider if @oneToOneCollisionCheck(one, collider)

	oneToOneCollisionCheck: (one, collider) ->
		if one isnt collider && one.owner isnt collider && collider.owner isnt one
			dx = one.position.x - collider.position.x
			dy = one.position.y - collider.position.y
			radi = (one.width + collider.width) / 2
			return true if (dx * dx + dy * dy) < (radi * radi)

	getNewCenter: ->
		center = new PIXI.Point(0,0)

		for player in @otherPlayers.children
			center.x += player.position.x
			center.y += player.position.y

		center.x += @player.position.x
		center.y += @player.position.y

		center.x = center.x / (@otherPlayers.children.length + 1)
		center.y = center.y / (@otherPlayers.children.length + 1)
		return center

	scaleMap: (center) ->
		cx = (globals.WIN_W/2) + Math.abs(center.x) * @world.scale.x
		cy = (globals.WIN_H/2) + Math.abs(center.y) * @world.scale.y
		scale = 1

		for player in @otherPlayers.children
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
	