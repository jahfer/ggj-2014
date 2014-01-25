$ ->
  PrismApp.stats = new Stats()
  PrismApp.stats.setMode(0)
  PrismApp.stats.domElement.style.position = 'absolute'
  PrismApp.stats.domElement.style.left = '0px'
  PrismApp.stats.domElement.style.right = '0px'

  $('body').append(PrismApp.stats.domElement)
