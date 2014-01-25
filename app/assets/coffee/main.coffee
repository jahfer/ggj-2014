$ ->
	stage = new PIXI.Stage(0x000000)
	world = new PIXI.DisplayObjectContainer();

	window.globals =
		WIN_W: 1000
		WIN_H: 700
		NUM_STARS: 50
		MAX_VEL: 10
		FRAMECOUNT: 0

	renderer = PIXI.autoDetectRenderer(globals.WIN_W,globals.WIN_H)
	players = new Array()
	socket = io.connect("http://localhost:3000")
	socket.emit('hello!', {my: 'data'})

	$('body').append(renderer.view)

	players.push(new PrismApp.Player({x: 0.5, y: 0.5}, {x: 200, y: 150}))
	players.push(new PrismApp.Player({x: 0.5, y: 0.5}, {x: 400, y: 150}))
	prism = new PrismApp.Prism({x: 0.5, y: 0.5}, {x: 300, y: 250})

	meteors = 10;
	for i in [0..10]
		obstacle = new PrismApp.Obstacle({x: 0.5, y: 0.5}, {x: 600, y: 250})
		world.addChild(obstacle)
	
	world.addChild(player) for player in players

	stage.addChild(prism)
	stage.addChild(world)

	move = new PIXI.Point(0,0);
	center = new PIXI.Point(0,0);
	minBound = new PIXI.Point(0,0);
	maxBound = new PIXI.Point(0,0);


	animate = ->
		move.x = 0
		move.y = 0
		center.x = 0
		center.y = 0
		#player.rotation += 0.1
		prism.rotation -= 0.1
		kd.tick()
		for player in players
			move.x += player.moveV.x
			move.y += player.moveV.y
			center.x += player.position.x
			center.y += player.position.y

		center.x = center.x / players.length
		center.y = center.y / players.length

		cx = (globals.WIN_W/2) + Math.abs(center.x) * world.scale.x
		cy = (globals.WIN_H/2) + Math.abs(center.y) * world.scale.y
		scale = 1;

		for player in players
			absx = Math.abs(player.position.x) + 100 
			absy = Math.abs(player.position.y) + 100 
			if absx > cx
				scale = Math.min(scale, cx/absx)

			if absy > cy
				scale = Math.min(scale, cy/absy)
        
		world.scale.x = scale
		world.scale.y = scale
		world.position.x = globals.WIN_W/2 - center.x * scale
		world.position.y = globals.WIN_H/2 - center.y * scale
		maxBound.x = center.x + globals.WIN_W/2/scale
		maxBound.y = center.y + globals.WIN_H/2/scale
		minBound.x = center.x - globals.WIN_W/2/scale
		minBound.y = center.y - globals.WIN_H/2/scale


		child.move() for child in world.children

		requestAnimFrame(animate)

		renderer.render(stage)
		false

	requestAnimFrame(animate)
