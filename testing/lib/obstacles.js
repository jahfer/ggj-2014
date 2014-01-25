// Generated by CoffeeScript 1.6.3
var __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

PrismApp.Obstacles = (function(_super) {
  __extends(Obstacles, _super);

  Obstacles.prototype.texture = PIXI.Texture.fromImage("images/prism.png");

  function Obstacles(anchor, position) {
    Obstacles.__super__.constructor.call(this, this.texture, anchor, position);
    this.velocity = 0;
    this.moveV = new PIXI.Point(0, 0);
    this.owner;
  }

  return Obstacles;

})(PrismApp.Renderable);
