// Generated by CoffeeScript 1.6.2
(function() {
  var Grid, array2d, buf, data, fixture, grid, height, width, zlib;

  Grid = require("../grid");

  fixture = require("./fixture");

  zlib = require('zlib');

  array2d = [[1, 0, 0], [0, 1, 0], [0, 0, 1], [1, 1, 0], [1, 0, 0]];

  width = 3;

  height = 5;

  buf = Grid.bytesFrom2DArray(width, height, array2d);

  grid = new Grid(width, height, buf);

  console.log("grid: " + grid);

  data = fixture[378];

  console.dir(data);

  zlib.inflate(new Buffer(data['blockdata'], 'base64'), function(err, buf) {
    var brickLocToString, checkEveryPoint, x, y;

    if (err != null) {
      throw "FATAL...fail to inflate scene asset json";
      return;
    }
    grid = new Grid(data.width, data.height, buf);
    console.log("grid2: " + grid);
    return;
    x = 0;
    y = 0;
    brickLocToString = function(brickLoc) {
      return "(" + (brickLoc >>> 16) + ", " + (brickLoc & 0xffff) + ")";
    };
    checkEveryPoint = function() {
      var neighbors;

      neighbors = grid.getNeighbors(x, y);
      console.log("[grid_test::checkEveryPoint] x:" + x + ", y:" + y + ", walkable:" + (grid.isWalkableAt(x, y)) + ", neighbors:" + (neighbors.map(brickLocToString)));
      ++x;
      if (x >= data.width) {
        x = 0;
        ++y;
      }
      if (y < data.height) {
        process.nextTick(function() {
          return checkEveryPoint();
        });
      }
    };
    checkEveryPoint();
  });

  return;

}).call(this);