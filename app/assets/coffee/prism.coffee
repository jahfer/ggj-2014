class PrismApp.Prism extends PrismApp.Renderable

	texture: PIXI.Texture.fromImage("images/prism.png")

	constructor: (anchor, position) ->
		super(@texture, anchor, position)

		