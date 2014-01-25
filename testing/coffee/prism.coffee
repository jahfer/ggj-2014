class PrismApp.Prism extends PrismApp.Renderable

	texture: PIXI.Texture.fromImage("images/lighthouse.png")

	constructor: (anchor, position) ->
		super(@texture, anchor, position)