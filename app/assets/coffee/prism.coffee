class PrismApp.Prism extends PrismApp.Renderable

	texture: PIXI.Texture.fromImage("images/prism.png")

	constructor: ->
		anchor = {x: 0.5, y: 0.5}
		@position = {}
		@move()

		super(@texture, anchor, @position)

		@velocity = 0
		@moveV = new PIXI.Point(0,0)
		@owner

	move: ->
		@position.x = Math.floor(Math.random() * (globals.WIN_W - 150 + 1)) + 100
		@position.y = Math.floor(Math.random() * (globals.WIN_H - 150 + 1)) + 100


		


