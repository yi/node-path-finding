# Node Path Finding

This is a Node.JS implementation for AStar path finding algorithm.
This implementation uses primitive data types (Number and Byte/Buffer) to present location and block data that significantly improve the speed and have a good control on memory consumption

## Installation

```bash
npm install node-pathfinding
```

## Advantages
- This module uses much less runtime memory then other node path finding module I can find on the net
- The path finding implementation uses primative JavaScript Number type, so much safe to memory leak
- Simple code, easy to change and extend

## Limitations
- The max size of map is limited to 65535 x 65535
- Does not support negtive location

## How To Use

```javascript
var array2d, buf, grid, height, path, pathfinding, width;

pathfinding = require("node-pathfinding");

array2d = [[1, 0, 0, 0], [0, 1, 0, 0], [0, 0, 1, 0], [1, 1, 0, 0], [1, 0, 0, 0]];

width = 4;

height = 5;

// generate grid from 2D array
buf = pathfinding.bytesFrom2DArray(width, height, array2d);
grid = pathfinding.buildGrid(width, height, buf);

path = pathfinding.findPath(1, 0, 1, 4, grid);

console.log("path:" + path);

// print the path
console.log("path on grid :" + (grid.toString(1 << 16 | 0, 1 << 16 | 4, path)));

// output:
// path:65536,131072,131073,196609,196610,196611,196612,131076,65540
// path on grid :[Grid(width=4, height=5)]
// Dump: ░=walkable, ▓=blocked
// ▓S1░
// ░▓23
// ░░▓4
// ▓▓░5
// ▓E76

```

## Glossary
- BrickLoc: To reduce memory usage and use less Object instances, each dot(node, point) in the given map is represented by an 32bit uint, which is composed by ` x << 16 | y `
- Map Buffer: The map is presented by a Buffer, column by row. Each dot(node, point) is a bit in the Buffer. 0 means walkable, 1 means blocked.

## Performance and Memory Consumption

Try ```node tests/sync_astar_continue_test.js```
it does a continuous test of pathfinding on some map fixtures, and the vm memory recycled correctly.



