Heap = require "./heap"

openList = new Heap()

startLoc = 0

endLoc = 0

grid = null

locToClosed = null

locToOpen = null

locToG = null

locToH = null

locToF = null

locToParent = null

SQRT2 = Math.SQRT2


# Backtrace according to the parent records and return the path.
# (including both start and end nodes)
# @param {uint} node End node
# @return the path array
backtrace = (node) ->
  path = []
  path.push(node)
  while (locToParent[node])
    node = locToParent[node]
    path.unshift(node)
  return path

syncfinder_astar =

  findPath : (startX, startY, endX, endY, theGrid) ->
    startLoc = startX << 16 | startY
    endLoc = endX << 16 | endY
    grid = theGrid
    locToClosed = {}
    locToOpen = {}
    locToG = {}
    locToF = {}
    locToH = {}
    locToParent = {}


    # set the `g` and `f` value of the start node to be 0
    locToG[startLoc] = 0
    locToF[startLoc] = 0

    # HERE


module.exports = syncfinder_astar




