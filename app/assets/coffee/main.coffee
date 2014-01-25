$ ->
	stage = new PIXI.Stage(0x000000)
	world = new PIXI.DisplayObjectContainer()

	window.globals =
		WIN_W: 1000
		WIN_H: 700
		NUM_STARS: 50
		MAX_VEL: 10
		FRAMECOUNT: 0

	renderer = PIXI.autoDetectRenderer(globals.WIN_W,globals.WIN_H)
	players = new Array()

	socket = new PrismApp.Socket()
	socket.emit('hello', foo: 'bar')

	$('body').append(renderer.view)

	players.push(new PrismApp.Player({x: 0.5, y: 0.5}, {x: 200, y: 150}, "W", "A", "S", "D"))
	players.push(new PrismApp.Player({x: 0.5, y: 0.5}, {x: 400, y: 150},"UP", "LEFT", "DOWN", "RIGHT"))
	prism = new PrismApp.Prism({x: 0.5, y: 0.5}, {x: 300, y: 250})

	meteors = 10
	for i in [0..10]
		obstacle = new PrismApp.Obstacle({x: 0.5, y: 0.5}, {x: 600, y: 250})
		world.addChild(obstacle)

	world.addChild(player) for player in players

	stage.addChild(prism)
	stage.addChild(world)

	minBound = new PIXI.Point(0,0)
	maxBound = new PIXI.Point(0,0)

	updatePlayers = ->
		for player in players
			hasCollided = false
			player.move()
			if !hasCollided && oneToManyCollisionCheck(player, players)
				console.log("collision!")

	oneToManyCollisionCheck = (one, many) ->
			for collider in many
				if one isnt collider && one.owner isnt collider && collider.owner isnt one
					dx = one.position.x - collider.position.x
					dy = one.position.y - collider.position.y
					radi = (one.width + collider.width) / 2
					return true if (dx * dx + dy * dy) < (radi * radi)

	getNewCenter = ->
		center = new PIXI.Point(0,0)

		for player in players
			center.x += player.position.x
			center.y += player.position.y

		center.x = center.x / players.length
		center.y = center.y / players.length
		return center

	scaleMap = (center) ->
		cx = (globals.WIN_W/2) + Math.abs(center.x) * world.scale.x
		cy = (globals.WIN_H/2) + Math.abs(center.y) * world.scale.y
		scale = 1

		for player in players
			absx = Math.abs(player.position.x) + 100
			absy = Math.abs(player.position.y) + 100

			if absy > cy
				scale = Math.min(scale, cy/absy)
			else if absx > cx
				scale = Math.min(scale, cx/absx)

		world.scale.x = scale
		world.scale.y = scale
		world.position.x = (globals.WIN_W / 2) - center.x * scale
		world.position.y = (globals.WIN_H / 2) - center.y * scale

		maxBound.x = center.x + (globals.WIN_W / 2) / scale
		maxBound.y = center.y + (globals.WIN_H / 2) / scale
		minBound.x = center.x - (globals.WIN_W / 2) / scale
		minBound.y = center.y - (globals.WIN_H / 2) / scale

	animate = ->
		PrismApp.stats.begin()
		kd.tick()

		updatePlayers()
		newCenter = getNewCenter()
		scaleMap(newCenter)

		requestAnimFrame(animate)
		renderer.render(stage)

		PrismApp.stats.end()
		false

	requestAnimFrame(animate)
