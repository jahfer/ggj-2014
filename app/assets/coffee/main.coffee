window.globals =
	WIN_W: 1000
	WIN_H: 700
	NUM_STARS: 50
	MAX_VEL: 10
	FRAMECOUNT: 0

class PrismApp.Main
	constructor: ->
		@stage = new PIXI.Stage(0x000000)
		@world = new PIXI.DisplayObjectContainer()
		@obstacles = new PIXI.DisplayObjectContainer()
		@players = new PIXI.DisplayObjectContainer()

		@renderer = PIXI.autoDetectRenderer(globals.WIN_W,globals.WIN_H)

		socket = new PrismApp.Socket()
		socket.emit('hello', foo: 'bar')

		$('body').append(@renderer.view)

		@players.addChild(new PrismApp.Player(0.5, 0.5, 200, 150, "W", "A", "S", "D"))
		@players.addChild(new PrismApp.Player(0.5, 0.5, 400, 150,"UP", "LEFT", "DOWN", "RIGHT"))
		@prism = new PrismApp.Prism()

		for i in [0..10]
			obstacle = new PrismApp.Obstacle({x: 0.5, y: 0.5}, {x: 600, y: 250})
			@obstacles.addChild(obstacle)

		@world.addChild(@obstacles)
		@world.addChild(@players)
		@world.addChild(@prism)

		#@stage.addChild(@prism)
		@stage.addChild(@world)

		@minBound = new PIXI.Point(0,0)
		@maxBound = new PIXI.Point(0,0)

	updatePlayers: ->
		for player in @players.children
			hasCollided = false
			player.move()

			if !hasCollided && @oneToManyCollisionCheck(player, @obstacles.children)
				hasCollided = true
				console.log("collision with obstacle!")

			if !hasCollided && @oneToOneCollisionCheck(player, @prism)
				hasCollided = true
				@prism.move()
				console.log("collision with prism!")


	oneToManyCollisionCheck: (one, many) ->
			for collider in many
				return true if @oneToOneCollisionCheck(one, collider)

	oneToOneCollisionCheck: (one, collider) ->
		if one isnt collider && one.owner isnt collider && collider.owner isnt one
			dx = one.position.x - collider.position.x
			dy = one.position.y - collider.position.y
			radi = (one.width + collider.width) / 2
			return true if (dx * dx + dy * dy) < (radi * radi)


	getNewCenter: ->
		center = new PIXI.Point(0,0)

		for player in @players.children
			center.x += player.position.x
			center.y += player.position.y

		center.x = center.x / @players.children.length
		center.y = center.y / @players.children.length
		return center

	scaleMap: (center) ->
		cx = (globals.WIN_W/2) + Math.abs(center.x) * @world.scale.x
		cy = (globals.WIN_H/2) + Math.abs(center.y) * @world.scale.y
		scale = 1

		for player in @players.children
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
	app = new PrismApp.Main()
	requestAnimFrame(app.draw)
