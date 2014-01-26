class PrismApp.Assets
  @playerTextures = []
  @ghostTextures = []
  @obstacleTextures = []
  @powerupTextures = []
  @prismTextures = []
  @playerPowerupTextures = []

  @spawnClips = []
  @playerGhostClips = []
  @ghostPlayerClips = []
  @fadePlayerClips = []
  @deathClips = []
  @powerupClips = []


  @spawns = new PIXI.DisplayObjectContainer()
  @playerGhosts = new PIXI.DisplayObjectContainer()
  @ghostPlayers = new PIXI.DisplayObjectContainer()
  @fadePlayers = new PIXI.DisplayObjectContainer()
  @deaths = new PIXI.DisplayObjectContainer()
  @powerups = new PIXI.DisplayObjectContainer()
  @playerPowerups = new PIXI.DisplayObjectContainer()

  @COLORS = ['blue', 'orange', 'pink', 'purple', 'red', 'yellow']

  @SIZES = ['small','medium','large']

  @TYPES = ['fast','invisible','shield','slow']

  @playerTextureFromColor: (color) ->
    index = @COLORS.indexOf(color)
    @playerTextures[index]

  @obstaclesTextureFromSize: (size) ->
    index = @SIZES.indexOf(size)
    @obstacleTextures[index]

  @ghostTextureFromColor: (color) ->
    index = @COLORS.indexOf(color)
    @ghostTextures[index]

  @playerSpawnFromColor: (color) ->
    index = @COLORS.indexOf(color)
    @spawnClips[index]
  
  @ghostFromPlayer: (color) ->
    index = @COLORS.indexOf(color)
    @playerGhostClips[index]
  
  @powerupTextureFromType: (type) ->
    index = @TYPES.indexOf(type)
    @powerupTextures[index]

  @powerupFromPlayer: (type,color) ->
    index1 = @COLORS.indexOf(color)
    index2 = @TYPES.indexOf(type)
    @playerPowerupTextures[index1][index2]


  @onAssetsLoaded: =>
    for i in [0..2]
      texture = PIXI.Texture.fromFrame ("obstacle_"+(i+1)+".png")
      @obstacleTextures.push(texture)
    
    for i in [0..3]
      texture = PIXI.Texture.fromFrame ("powerup_"+(i+1)+".png")
      @powerupTextures.push(texture)

    for i in [0..5]
      texture = PIXI.Texture.fromFrame ("ghost_"+(i+1)+".png")
      @ghostTextures.push(texture)
      texture = PIXI.Texture.fromFrame ("player_"+(i+1)+".png")
      @playerTextures.push(texture)

    textures = []
    prism = []
    playerGhost = []
    ghostPlayer = []
    fadePlayer = []
    death = []
    powerup = []

    for i in [1..6]
      textures[i-1] = for j in [0..26]
        num = ("00" + j).slice(-3)
        PIXI.Texture.fromFrame("spawn-#{i}_#{num}.png")
      
      playerGhost[i-1] = for j in [0..26]
        num = ("00" + j).slice(-3) 
        PIXI.Texture.fromFrame("player-ghost-#{i}_#{num}.png")

      ghostPlayer[i-1] = for j in [0..26]
        num = ("00" + j).slice(-3) 
        PIXI.Texture.fromFrame("ghost-player-#{i}_#{num}.png")
      
      fadePlayer[i-1] = for j in [0..26]
        num = ("00" + j).slice(-3) 
        PIXI.Texture.fromFrame("fade-player-#{i}_#{num}.png")
    
      death[i-1] = for j in [0..23]
        num = ("00" + j).slice(-3) 
        PIXI.Texture.fromFrame("death-#{i}_#{num}.png")
    
    prism = for j in [0..26]
        num = ("00" + j).slice(-3) 
        PIXI.Texture.fromFrame("prism-spawn_#{num}.png")
    
    for i in [1..4]
      powerup[i-1] = for j in [0..26]
        num = ("00" + j).slice(-3) 
        PIXI.Texture.fromFrame("powerup-#{i}_#{num}.png")

    for i in [1..6]   
      @playerPowerupTextures[i-1] = for j in [1..4]
        PIXI.Texture.fromFrame("player_#{i}_powerup_#{j}.png")

    for textureList in textures
      mc = new PIXI.MovieClip(textureList)
      mc.position.x = 250
      mc.position.y = 250
      mc.anchor.x = .5
      mc.anchor.y = .5
      mc.animationSpeed = .5
      mc.loop = false
      @spawnClips.push(mc)
      @spawns.addChild(mc)

    for playerGhostList in playerGhost
      mc = new PIXI.MovieClip(playerGhostList)
      mc.position.x = 250
      mc.position.y = 250
      mc.anchor.x = .5
      mc.anchor.y = .5
      mc.animationSpeed = .5
      mc.visible = false
      mc.loop = false
      @playerGhostClips.push(mc)
      @playerGhosts.addChild(mc)

    for ghostPlayerList in ghostPlayer
      mc = new PIXI.MovieClip(ghostPlayerList)
      mc.position.x = 250
      mc.position.y = 250
      mc.anchor.x = .5
      mc.anchor.y = .5
      mc.animationSpeed = .5
      mc.visible = false
      mc.loop = false
      @ghostPlayerClips.push(mc)
      @ghostPlayers.addChild(mc)

    for fadePlayerList in fadePlayer
      mc = new PIXI.MovieClip(fadePlayerList)
      mc.position.x = 250
      mc.position.y = 250
      mc.anchor.x = .5
      mc.anchor.y = .5
      mc.animationSpeed = .5
      mc.visible = false
      mc.loop = false
      @fadePlayerClips.push(mc)
      @fadePlayers.addChild(mc)
    
    for powerupList in powerup
      mc = new PIXI.MovieClip(powerupList)
      mc.position.x = 250
      mc.position.y = 250
      mc.anchor.x = .5
      mc.anchor.y = .5
      mc.animationSpeed = .5
      mc.visible = false
      mc.loop = false
      @powerupClips.push(mc)
      @powerups.addChild(mc)

    for deathList in death
      mc = new PIXI.MovieClip(deathList)
      mc.position.x = 250
      mc.position.y = 250
      mc.anchor.x = .5
      mc.anchor.y = .5
      mc.animationSpeed = .5
      mc.loop = false
      @deathClips.push(mc)
      @deaths.addChild(mc)

    @prismClip = new PIXI.MovieClip(prism)
    @prismClip.position.x = 250
    @prismClip.position.y = 250
    @prismClip.anchor.x = .5
    @prismClip.anchor.y = .5
    @prismClip.animationSpeed = .5
    @prismClip.loop = false
    @prismClip.visible = false
      
