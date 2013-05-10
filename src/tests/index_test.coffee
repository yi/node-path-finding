pathfinding = require "../../index"

# test building a map buffer from 2d array
array2d = [
  [1, 0, 0, 0],
  [0, 1, 0, 0],
  [0, 0, 1, 0],
  [1, 1, 0, 0],
  [1, 0, 0, 0]
]

width = 4
height = 5

# convert array map into grid buffer
buf = pathfinding.bytesFrom2DArray(width, height, array2d)

# build grid from grid buffer
grid = pathfinding.buildGrid(width, height, buf)

# find path
path = pathfinding.findPath(1,0,1,4,grid)

console.log "path:#{path}"
console.log "path on grid :#{grid.toString(1<<16|0, 1<<16|4, path)}"




