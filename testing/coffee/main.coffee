$ ->
	stage = new PIXI.Stage(0x000000)
	NUM_STARS = 50
	MAX_VEL = 10
	frameCount =  0

	renderer = PIXI.autoDetectRenderer(1000,700)

	$('body').append(renderer.view)

	player = new PrismApp.Player({x: 0.5, y: 0.5}, {x: 200, y: 150}, 0)
	prism = new PrismApp.Prism({x: 0.5, y: 0.5}, {x: 300, y: 250}, 0)

	stage.addChild(player)
	stage.addChild(prism)

	animate = -> 
		requestAnimFrame(animate)
		player.rotation += 0.1
		renderer.render(stage)
		false
	
	requestAnimFrame(animate)