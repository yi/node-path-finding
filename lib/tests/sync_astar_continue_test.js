// Generated by CoffeeScript 1.3.3
(function() {
  var Grid, MAP_ID, countFailure, countSuccess, countTimes, data, fixture, grid, maxMSSpent, maxMemoryUsed, memwatch, syncfinder_astar, totalMsSpent, zlib;

  Grid = require("../grid");

  fixture = require("./fixture");

  zlib = require('zlib');

  syncfinder_astar = require("../syncfinder_astar");

  memwatch = require('memwatch');

  MAP_ID = 15;

  data = fixture[MAP_ID];

  console.dir(data);

  grid = null;

  countSuccess = 0;

  countFailure = 0;

  countTimes = 0;

  totalMsSpent = 0;

  maxMSSpent = 0;

  maxMemoryUsed = 0;

  memwatch.on('leak', function(info) {
    console.log("LEAK! info:");
    console.dir(info);
    throw new Error("MEMORY LEAK DETECTED!");
  });

  memwatch.on('stats', function(stats) {
    console.log("memory stats:");
    console.dir(stats);
  });

  zlib.inflate(new Buffer(data['blockdata'], 'base64'), function(err, buf) {
    if (err != null) {
      throw "FATAL...fail to inflate scene asset json";
      return;
    }
    grid = new Grid(data.width, data.height, buf);
    console.log("grid: " + grid);
    setInterval(function() {
      var end, mem, memUsed, msSpent, now, path, start;
      ++countTimes;
      while (true) {
        start = grid.getARandomWalkableBrick();
        end = grid.getARandomWalkableBrick();
        if (start !== end) {
          break;
        }
      }
      now = Date.now();
      path = syncfinder_astar.findPathByBrickLoc(start, end, grid);
      msSpent = Date.now() - now;
      if (path != null) {
        ++countSuccess;
      } else {
        ++countFailure;
      }
      totalMsSpent += msSpent;
      if (msSpent > maxMSSpent) {
        maxMSSpent = msSpent;
      }
      console.log("find path, ms spent:" + msSpent + ": path: " + (grid.toString(start, end, path)));
      mem = process.memoryUsage();
      memUsed = mem['heapUsed'] / 1024 / 1024;
      if (memUsed > maxMemoryUsed) {
        maxMemoryUsed = memUsed;
      }
      console.log("MAP[" + MAP_ID + "] Test times: " + countTimes + ", succeed:" + countSuccess + ", failed:" + countFailure + ", mem:" + memUsed + "M, maxMemoryUsed:" + maxMemoryUsed + "M  ms:" + msSpent + ", max:" + maxMSSpent + ", avg. ms:" + (totalMsSpent / countTimes));
    }, 500);
  });

  return;

}).call(this);