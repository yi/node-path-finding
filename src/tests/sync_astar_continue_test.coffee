Grid = require "../grid"
fixture = require "./fixture"
zlib = require 'zlib'
syncfinder_astar = require "../syncfinder_astar"
memwatch = require 'memwatch'


# building a map buffer from compressed bytes
MAP_ID = 15
data = fixture[MAP_ID]  # 9, 15, 32, 378, 395
console.dir data

grid = null

countSuccess = 0
countFailure = 0
countTimes = 0
totalMsSpent = 0
maxMSSpent = 0
maxMemoryUsed = 0

memwatch.on 'leak', (info)->
  console.log "LEAK! info:"
  console.dir info
  throw new Error "MEMORY LEAK DETECTED!"
  return

memwatch.on 'stats', (stats)->
  console.log "memory stats:"
  console.dir stats
  return


# uncompress block data
zlib.inflate new Buffer(data['blockdata'],'base64'), (err, buf) ->
  if err?
    throw "FATAL...fail to inflate scene asset json"
    return

  grid = new Grid(data.width, data.height, buf)

  console.log "grid: #{grid}"


  setInterval ->
    ++countTimes
    loop
      start = grid.getARandomWalkableBrick()
      end = grid.getARandomWalkableBrick()
      break if start isnt end

    now = Date.now()
    path = syncfinder_astar.findPathByBrickLoc(start, end, grid)
    msSpent = Date.now() - now

    if path?
      ++countSuccess
    else
      ++countFailure

    totalMsSpent += msSpent
    maxMSSpent = msSpent if msSpent > maxMSSpent
    # print out the path
    console.log "find path, ms spent:#{msSpent}: path: #{grid.toString(start, end, path)}"
    # log stats
    mem = process.memoryUsage()
    memUsed = mem['heapUsed'] / 1024 / 1024
    maxMemoryUsed = memUsed if memUsed > maxMemoryUsed
    console.log "MAP[#{MAP_ID}] Test times: #{countTimes}, succeed:#{countSuccess}, failed:#{countFailure}, mem:#{memUsed}M, maxMemoryUsed:#{maxMemoryUsed}M  ms:#{msSpent}, max:#{maxMSSpent}, avg. ms:#{totalMsSpent / countTimes}"
    return
  , 500


  return



return












