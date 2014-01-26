var colorList = ['blue', 'orange', 'pink', 'purple', 'red', 'yellow'];
var colorQueue = colorList.slice(0);
var usedColors = [];

reloadColorQueue = function() {
  colorQueue = colorList.slice(0);
  usedColors = [];
}

module.exports = {
  nextColor: function() {
    console.log('colorList: ', colorList)
    console.log('colorQueue:', colorQueue)
    console.log('usedColors:', usedColors)

    if (colorQueue.length == 0) reloadColorQueue()

    nextColor = colorQueue.shift()
    usedColors.push(nextColor)

    return nextColor
  }
}
