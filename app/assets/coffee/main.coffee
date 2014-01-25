$ ->
	stage = new PIXI.Stage(0x000000)
	world = new PIXI.DisplayObjectContainer();

	window.globals =
		WIN_W: 1000
		WIN_H: 700
		NUM_STARS: 50
		MAX_VEL: 10

	frameCount =  0

	renderer = PIXI.autoDetectRenderer(globals.WIN_W,globals.WIN_H)

	socket = io.connect("http://localhost:3000")
	socket.emit('hello!', {my: 'data'})

	$('body').append(renderer.view)

	player = new PrismApp.Player({x: 0.5, y: 0.5}, {x: 200, y: 150})
	prism = new PrismApp.Prism({x: 0.5, y: 0.5}, {x: 300, y: 250})

	meteors = 10;
	for i in [0..10]
		obstacle = new PrismApp.Obstacle({x: 0.5, y: 0.5}, {x: 600, y: 250})
		world.addChild(obstacle)
	

	stage.addChild(player)
	stage.addChild(prism)
	stage.addChild(world)

	animate = ->
		requestAnimFrame(animate)
		player.rotation += 0.1
		prism.rotation -= 0.1
		renderer.render(stage)
		false

	requestAnimFrame(animate)
