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

# Manhattan distance.
heuristic = (dx, dy) ->
  return dx + dy

# Backtrace according to the parent records and return the path.
# (including both start and end nodes)
# @param {uint} node End node
# @return the path array
backtrace = (node) ->
  #console.log "[syncfinder_astar::backtrace] node:#{node}"

  path = []
  path.push(node)
  while (locToParent[node])
    node = locToParent[node]
    path.unshift(node)
  return path

syncfinder_astar =

  findPathByBrickLoc : (start, end, theGrid) ->
    return syncfinder_astar.findPath(start >>> 16 , start & 0xffff, end >>> 16, end & 0xffff, theGrid)

  # find a path of giving x, y brick locations
  findPath : (startX, startY, endX, endY, theGrid, allowDiagonal=false, dontCrossCorners=false) ->

    # validate arguments
    if isNaN(startX) or startX < 0 or isNaN(startY) or startY < 0 or isNaN(endX) or endX < 0 or isNaN(endY) or endY < 0 or not theGrid
      console.log "ERROR [syncfinder_astar::findPath] bad arguments, startX:#{startX}, startY:#{startY}, endX:#{endX}, endY:#{endY}, theGrid:#{theGrid}"
      return null

    startLoc = startX << 16 | startY
    endLoc = endX << 16 | endY
    grid = theGrid
    locToClosed = {}
    locToOpen = {}
    locToG = {}
    locToF = {}
    locToH = {}
    locToParent = {}

    #console.log "[syncfinder_astar::findPath] startX:#{startX}, startY:#{startY}, endX:#{endX}, endY:#{endY}" #,theGrid:#{theGrid.toString(startLoc, endLoc)}"

    # set the `g` and `f` value of the start node to be 0
    locToG[startLoc] = 0
    locToF[startLoc] = 0

    openList.reset(locToF)

    openList.push(startLoc)
    locToOpen[startLoc] = true

    while(openList.isNotEmpty())
      # pop the position of node which has the minimum `f` value.
      node = openList.pop()

      locToClosed[node] = true

      if node is endLoc
        #console.log "[syncfinder_astar::findPath] hit end brick"
        return backtrace(node)

      # get neighbors of the current node
      nodeX = node >>> 16
      nodeY = node & 0xffff
      neighbors = grid.getNeighbors(nodeX , nodeY, allowDiagonal, dontCrossCorners)

      #console.log "[syncfinder_astar::findPath] process node:#{node}, x:#{nodeX}, y:#{nodeY}, neighbors:#{neighbors}"

      for neighbor in neighbors
        if locToClosed[neighbor]
          #console.log "[syncfinder_astar::findPath] met closed node@#{neighbor}, x:#{neighbor >>> 16}, y:#{neighbor&0xffff}"
          continue

        x = neighbor >>> 16
        y = neighbor & 0xffff

        # get the distance between current node and the neighbor
        # and calculate the next g score
        ng = locToG[node] + (if x is nodeX or y is nodeY then 1 else SQRT2)
        #console.log "[syncfinder_astar::findPath] ng:#{ng}, locToOpen[neighbor]:#{locToOpen[neighbor]}, locToG[neighbor]:#{locToG[neighbor]}, node:#{node}"

        # check if the neighbor has not been inspected yet, or
        # can be reached with smaller cost from the current node
        if (not locToOpen[neighbor]) or (ng < locToG[neighbor])
          locToG[neighbor] = ng
          locToH[neighbor] = locToH[neighbor] or  heuristic(Math.abs(x - endX) , Math.abs(y - endY))
          locToF[neighbor] = locToG[neighbor] + locToH[neighbor]
          neighborNode = x << 16 | y
          locToParent[neighborNode] = node

          unless locToOpen[neighbor]
            openList.push(neighborNode)
            locToOpen[neighbor] = true
          else
            # the neighbor can be reached with smaller cost.
            # Since its f value has been updated, we have to
            # update its position in the open list
            openList.updateItem(neighborNode)

    # fail to find the path
    return null



module.exports = syncfinder_astar




