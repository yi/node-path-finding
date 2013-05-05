
Grid = require "../grid"
fixture = require "./fixture"
zlib = require 'zlib'
syncfinder_astar = require "../syncfinder_astar"


# check getNeighbors
chkGetNeighbors = (width, height, grid) ->
  console.log "[chkGetNeighbors] width:#{width}, height:#{height}, grid:#{grid}"
  for y in [0...height]
    for x in [0...width]
      neighbors = grid.getNeighbors(x, y)
      console.log "neighbors@x:#{x}, y:#{y}, neighbors:#{neighbors}, #{grid.toString(x << 16 | y, null, neighbors)}"
  return


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
# check getNeighbors
#chkGetNeighbors(width, height, grid)

path = syncfinder_astar.findPath(1,0,1,4,grid)
console.log "path:#{path}"

return

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


return









