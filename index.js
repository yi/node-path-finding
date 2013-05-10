Grid = require("./lib/grid");
syncfinder_astar = require("./lib/syncfinder_astar.js");


module.exports = {

  bytesFrom2DArray : Grid.bytesFrom2DArray ,
  findPath : syncfinder_astar.findPath,
  findPathByBrickLoc: syncfinder_astar.findPathByBrickLoc,
  buildGrid : function(width, height, buf)
  {
    return new Grid(width, height, buf)
  }

}



