var spawnPositions = {
  player: [
    {x:85, y:85, rot:Math.PI/2},
    {x:85, y:480, rot:Math.PI/2},
    {x:85, y:860, rot:Math.PI/2},
    {x:85, y:1245, rot:Math.PI/2},
    {x:85, y:1640, rot:Math.PI/2},
    {x:85, y:2025, rot:Math.PI/2},
    {x:85, y:2400, rot:Math.PI/2},
    {x:1060, y:2400, rot:0},
    {x: 2000, y:2400, rot: 0},
    {x: 2940, y:2400, rot: 0},
    {x:3920, y:2400, rot: -Math.PI/2},
    {x:3920, y:2025, rot: -Math.PI/2},
    {x:3920, y:1640, rot: -Math.PI/2},
    {x:3920, y:1245, rot: -Math.PI/2},
    {x:3920, y:860, rot: -Math.PI/2},
    {x:3920, y:480, rot: -Math.PI/2},
    {x:3920, y:85, rot:-Math.PI/2}
  ],

  smallObject: [
    {x:570, y:1250, rot:0},
    {x:380, y:2300, rot:0},
    {x:3445, y:1250, rot:0},
    {x:3625, y:2312, rot:0}
  ],

  mediumObject: [
    {x:570, y:1732, rot:0},
    {x:570, y:767, rot:0},
    {x:2000, y:40, rot:0},
    {x:3435, y:768, rot:0},
    {x:3435, y:1733, rot:0}
  ],

  largeObject: [
    {x:1142, y:574, rot:Math.PI/4},
    {x:1142, y:1980, rot:-Math.PI/4},
    {x:2863, y:1980, rot:Math.PI/4},
    {x:2863, y:574, rot:-Math.PI/4}
  ],

  powerupList: [
    {x:817, y:1556, rot:0},
    {x:817, y:980,rot:0},
    {x:1014, y:230, rot:0},
    {x:1749, y:955, rot:0},
    {x:1749, y:1502, rot:0},
    {x:2257, y:955, rot:0},
    {x:2257, y:1502,rot:0},
    {x:2991, y:231, rot:0},
    {x:3188, y:981, rot:0},
    {x:3188, y:1556, rot:0}
  ],

  prism: [
    {x: 570, y:381, rot:0},
    {x: 570, y: 2118, rot:0},
    {x:951, y:1250, rot:0},
    {x: 1523, y: 767, rot:0},
    {x: 1523, y:1732, rot:0},
    {x: 2000, y:1250, rot:0},
    {x: 2482, y: 768, rot:0},
    {x: 2482, y:1733, rot:0},
    {x: 3435, y: 382, rot:0},
    {x: 3435, y:2119, rot:0}
  ]
}

var randomFor = function (type) {
  index = Math.floor(Math.random() * spawnPositions[type].length)
  return spawnPositions[type][index]
};

var usedPowerups = [];
var powerupQueue = spawnPositions['powerupList'].slice(0);

var nextPowerup = function() {
  if (powerupQueue.length == 0) return

  var powerupTypes = ['fast', 'slow', 'invisible'];

  var randomIndex = Math.floor(Math.random() * spawnPositions['powerupList'].length);
  var nextPowerup = powerupQueue[randomIndex];
  usedPowerups.push(nextPowerup);

  randomType = Math.floor(Math.random() * powerupTypes.length)

  return {id: randomIndex, powerup: nextPowerup, type: powerupTypes[randomType]};
};

module.exports = {
  nextPowerup: nextPowerup
}
