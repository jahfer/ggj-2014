class PrismApp.Renderable extends PIXI.Sprite

	constructor: (@texture, anchor, position) ->
		super(@texture)

		@anchor.x = anchor.x
		@anchor.y = anchor.y

		@position.x = position.x
		@position.y = position.y
