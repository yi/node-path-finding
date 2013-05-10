# Node Path Finding

Is is a simple path finding module for NodeJS.
This module is designed to be run on the server side


## Installation

```
npm install node-pathfinding
```


## Advantages
- This module use much less runtime memory then other node path finding module I can find on the net
- The path finding implementation uses primative JavaScript Number type, so much safe to memory leak
- Simple code, easy to change and extend

## Limitations
- The max size of map is limited to 65535 x 65535
- Doesn't support nagtive location

## Glossary
- BrickLoc: To reduce memory usage and use less Object instances, each dot(node, point) in the given map is represented by an 32bit uint, which is composed by ` x << 16 | y `
- Map Buffer: The map is presented by a Buffer, column by row. Each dot(node, point) is a bit in the Buffer. 0 means walkable, 1 means blocked.

## How To Use

```coffee
pathfinding = require "node-pathfinding"

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
```





