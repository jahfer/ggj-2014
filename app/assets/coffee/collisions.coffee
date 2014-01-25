class PrismApp.Collisions
  @oneToManyCollisionCheck: (one, many) ->
      for collider in many
        return collider if @oneToOneCollisionCheck(one, collider)

  @oneToOneCollisionCheck: (one, collider) ->
    if one isnt collider && one.owner isnt collider && collider.owner isnt one
      dx = one.position.x - collider.position.x
      dy = one.position.y - collider.position.y
      radi = (one.width + collider.width) / 2
      return true if (dx * dx + dy * dy) < (radi * radi)
