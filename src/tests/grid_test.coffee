Grid = require "../grid"
fixture = require "./fixture"
zlib = require 'zlib'

# test building a map buffer from 2d array
array2d = [
  [1, 0, 0],
  [0, 1, 0],
  [0, 0, 1],
  [1, 1, 0],
  [1, 0, 0]
]

width = 3
height = 5
buf = Grid.bytesFrom2DArray(width, height, array2d)
grid = new Grid(width, height, buf)
console.log "grid: #{grid}"

# building a map buffer from compressed bytes
data = fixture[378]
console.dir data

# uncompress block data
zlib.inflate new Buffer(data['blockdata'],'base64'), (err, buf) ->
  if err?
    throw "FATAL...fail to inflate scene asset json"
    return

  grid = new Grid(data.width, data.height, buf)

  console.log "grid2: #{grid}"

  return
  x = 0
  y = 0

  brickLocToString = (brickLoc) ->
    return "(#{brickLoc >>> 16}, #{brickLoc & 0xffff})"


  checkEveryPoint = ->
    neighbors = grid.getNeighbors(x, y)
    console.log "[grid_test::checkEveryPoint] x:#{x}, y:#{y}, walkable:#{grid.isWalkableAt(x,y)}, neighbors:#{neighbors.map(brickLocToString)}"
    #console.log "[grid_test::checkEveryPoint] x:#{x}, y:#{y}, walkable:#{grid.isWalkableAt(x,y)}, neighbors:#{neighbors}"
    ++x
    if x >= data.width
      x = 0
      ++ y
    if y < data.height then process.nextTick ->
      checkEveryPoint()
    return


  #console.log grid.isWalkableAt 0, 95
  #console.log grid.getNeighbors 0, 95

  checkEveryPoint()

  return


return









