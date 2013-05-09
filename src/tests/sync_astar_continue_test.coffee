Grid = require "../grid"
fixture = require "./fixture"
zlib = require 'zlib'
syncfinder_astar = require "../syncfinder_astar"


# building a map buffer from compressed bytes
data = fixture[378]
console.dir data

grid = null

countSuccess = 0
countFailure = 0
countTimes = 0
totalMsSpent = 0

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
    console.log "find path, ms spent:#{msSpent}: path: #{grid.toString(start, end, path)}"
    console.log "Test times: #{countTimes}, succeed:#{countSuccess}, failed:#{countFailure}, ms:#{msSpent}, avg. ms:#{totalMsSpent / countTimes}"
    return
  , 500


  return


return












