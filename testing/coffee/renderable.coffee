class PrismApp.Renderable extends PIXI.Sprite

	constructor: (@texture, anchor, position, velocity) ->
		super(@texture)

		@anchor.x = anchor.x
		@anchor.y = anchor.y

		@position.x = position.x
		@position.y = position.y

		@velocity = velocity
		@moveV = new PIXI.Point(0,0)

	move: ->
		@moveV.x = @velocity * Math.cos(@rotation - Math.PI / 2);
		@moveV.y = @velocity * Math.sin(@rotation - Math.PI / 2);

		@position.x += moveV.x
		@position.y += moveV.y