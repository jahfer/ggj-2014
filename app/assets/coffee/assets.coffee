class PrismApp.Assets
  @playerTextures = []
  @ghostTextures = []
  @obstacleTextures = []
  @spawnClips = []
  @playerGhostClips = []
  @ghostPlayerClips = []
  @fadePlayerClips = []
  @deathClips = []

  @spawns = new PIXI.DisplayObjectContainer()
  @playerGhosts = new PIXI.DisplayObjectContainer()
  @ghostPlayers = new PIXI.DisplayObjectContainer()
  @fadePlayers = new PIXI.DisplayObjectContainer()
  @deaths = new PIXI.DisplayObjectContainer()


  @deathTextures6 = []

  @COLORS = ['blue', 'orange', 'pink', 'purple', 'red', 'yellow']

  @SIZES = ['small','medium','large']

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

  @onAssetsLoaded: =>
    for i in [0..2]
      texture = PIXI.Texture.fromFrame ("obstacle_"+(i+1)+".png")
      @obstacleTextures.push(texture)

    for i in [0..5]
      texture = PIXI.Texture.fromFrame ("ghost_"+(i+1)+".png")
      @ghostTextures.push(texture)
      texture = PIXI.Texture.fromFrame ("player_"+(i+1)+".png")
      @playerTextures.push(texture)

    textures = []
    playerGhost = []
    ghostPlayer = []
    fadePlayer = []
    death = []

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

      # death[i-1] = for j in [0..26]
      #   num = ("00" + j).slice(-3) 
      #   PIXI.Texture.fromFrame("death-#{i}_#{num}.png")

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
      mc.loop = false
      @fadePlayerClips.push(mc)
      @fadePlayers.addChild(mc)
    
    # for deathList in death
    #   mc = new PIXI.MovieClip(deathList)
    #   mc.position.x = 250
    #   mc.position.y = 250
    #   mc.anchor.x = .5
    #   mc.anchor.y = .5
    #   mc.animationSpeed = .5
    #   mc.loop = false
    #   @deathClips.push(mc)
    #   @deaths.addChild(mc)
