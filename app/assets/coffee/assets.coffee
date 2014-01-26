class PrismApp.Assets
  @playerTextures = []
  @ghostTextures = []
  @obstacleTextures = []
  @spawnClips = []

  @deathTextures6 = []

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
    for i in [1..6]
      textures[i-1] = for j in [0..26]
        num = ("00" + j).slice(-3)
        PIXI.Texture.fromFrame("spawn-#{i}_#{num}.png")

    for textureList in textures
      mc = new PIXI.MovieClip(textureList)
      mc.position.x = 250
      mc.position.y = 250
      mc.anchor.x = .5
      mc.anchor.y = .5
      mc.animationSpeed = .5
      mc.loop = true
      @spawnClips.push(mc)

    @spawnClips[0].play()


    #   if i < 10
    #     # texture7 = PIXI.Texture.fromFrame ("death-1_00"+(i)+".png")
    #     # texture8 = PIXI.Texture.fromFrame ("death-2_00"+(i)+".png")
    #     # texture9 = PIXI.Texture.fromFrame ("death-3_00"+(i)+".png")
    #     # texture10 = PIXI.Texture.fromFrame ("death-4_00"+(i)+".png")
    #     # texture11 = PIXI.Texture.fromFrame ("death-5_00"+(i)+".png")
    #     texture12 = PIXI.Texture.fromFrame ("death-6_00"+(i)+".png")
    #     texture13 = PIXI.Texture.fromFrame ("powerup-1_00"+(i)+".png")
    #     texture14 = PIXI.Texture.fromFrame ("powerup-2_00"+(i)+".png")
    #     texture15 = PIXI.Texture.fromFrame ("powerup-3_00"+(i)+".png")
    #     texture16 = PIXI.Texture.fromFrame ("powerup-4_00"+(i)+".png")
    #     texture17 = PIXI.Texture.fromFrame ("prism-spawn_00"+(i)+".png")
    #   else
    #     # texture7 = PIXI.Texture.fromFrame ("death-1_0"+(i)+".png")
    #     # texture8 = PIXI.Texture.fromFrame ("death-2_0"+(i)+".png")
    #     # texture9 = PIXI.Texture.fromFrame ("death-3_0"+(i)+".png")
    #     # texture10 = PIXI.Texture.fromFrame ("death-4_0"+(i)+".png")
    #     # texture11 = PIXI.Texture.fromFrame ("death-5_0"+(i)+".png")
    #     texture12 = PIXI.Texture.fromFrame ("death-6_0"+(i)+".png")
    #     texture13 = PIXI.Texture.fromFrame ("powerup-1_0"+(i)+".png")
    #     texture14 = PIXI.Texture.fromFrame ("powerup-2_0"+(i)+".png")
    #     texture15 = PIXI.Texture.fromFrame ("powerup-3_0"+(i)+".png")
    #     texture16 = PIXI.Texture.fromFrame ("powerup-4_0"+(i)+".png")
    #     texture17 = PIXI.Texture.fromFrame ("prism-spawn_0"+(i)+".png")
    #   # @deathTextures1.push(texture7)
    #   # @deathTextures2.push(texture8)
    #   # @deathTextures3.push(texture9)
    #   # @deathTextures4.push(texture10)
    #   # @deathTextures5.push(texture11)
    #   @deathTextures6.push(texture12)

    # #spawn6.play()
    # # death1 = new PIXI.MovieClip(@deathTextures1)
    # # death1.position.x = 250
    # # death1.position.y = 250
    # # death1.anchor.x = .5
    # # death1.anchor.y = .5
    # # death1.animationSpeed = .5
    # # death1.loop = false
    # # death1.play()

    # # death2 = new PIXI.MovieClip(@deathTextures2)
    # # death2.position.x = 250
    # # death2.position.y = 250
    # # death2.anchor.x = .5
    # # death2.anchor.y = .5
    # # death2.animationSpeed = .5
    # # death2.loop = false
    # # death2.play()
    # # death3 = new PIXI.MovieClip(@deathTextures3)
    # # death3.position.x = 250
    # # death3.position.y = 250
    # # death3.anchor.x = .5
    # # death3.anchor.y = .5
    # # death3.animationSpeed = .5
    # # death3.loop = false
    # # death3.play()
    # # death4 = new PIXI.MovieClip(@deathTextures4)
    # # death4.position.x = 250
    # # death4.position.y = 250
    # # death4.anchor.x = .5
    # # death4.anchor.y = .5
    # # death4.animationSpeed = .5
    # # death4.loop = false
    # # death4.play()
    # # death5 = new PIXI.MovieClip(@deathTextures5)
    # # death5.position.x = 250
    # # death5.position.y = 250
    # # death5.anchor.x = .5
    # # death5.anchor.y = .5
    # # death5.animationSpeed = .5
    # # death5.loop = false
    # # death5.play()
    # death6 = new PIXI.MovieClip(@deathTextures6)
    # death6.position.x = 250
    # death6.position.y = 250
    # death6.anchor.x = .5
    # death6.anchor.y = .5
    # death6.animationSpeed = .5
    # death6.loop = false
    # #death6.play()
    # #if i == 26
    # #testTexture.stop()
    # # @stage.addChild(@spawn1)
    # # @stage.addChild(spawn2)
    # # @stage.addChild(spawn3)
    # # @stage.addChild(spawn4)
    # # @stage.addChild(@spawn5)
    # # @stage.addChild(spawn6)
    # # @stage.addChild(death6)

    # # for i in [0..2]
    # #   texture = PIXI.Texture.fromFrame ("obstacle_"+(i+1)+".png")
    # #   @playerTextures.push(texture)
