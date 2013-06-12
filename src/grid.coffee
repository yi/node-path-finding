# an data representation of the map grid, on which path finding occurs
class Grid


  # generate a map buffer from the given 2d array
  # @param {uint} width of the map
  # @param {uint} height of the map
  # @param {Array[Array]} 2D map array,  1: means blocked, 0: means walkable
  @bytesFrom2DArray : (width, height, array2d) ->
    if isNaN(width) or width <= 0 or isNaN(height) or height <= 0 or not Array.isArray(array2d)
      console.log "ERROR [grid$::bytesFrom2DArray] bad arguments, width:#{width}, height:#{height}, array2d:#{array2d}"
      return null

    buf = new Buffer(Math.ceil(width * height / 8))
    #console.log "len:#{buf.length}"
    buf.fill(255) # fill all bits as blocked

    for row, y in array2d
      for col, x in row
        unless Boolean(col) # 0: means walkable
          index = y * width + x
          byteIndex = index >>> 3
          offset = 7 - (index % 8) #从高位向低位写
          byte = buf[byteIndex]
          byte = byte ^ 1 << offset
          buf[byteIndex] = byte
          #console.log "[grid$::bytesFrom2DArray] walkable at x:#{x}, y:#{y}, row:#{row}, index:#{index}, offset:#{offset}, byteIndex:#{byteIndex}"
    return buf


  # constructor function
  # @param {uint} width of the map grid
  # @param {uint} height of the map grid
  # @param {Buffer} bytes of the map grid,  1: means blocked, 0: means walkable
  constructor: (@width, @height, @bytes) ->
    unless width > 0 and height > 0 and Buffer.isBuffer(bytes)
      throw new Error "bad arguments, width:#{width}, height:#{height}, bytes:#{bytes}"

    unless bytes.length is Math.ceil(width * height / 8)
      throw new Error "bytes length mismatch, width:#{width}, height:#{height}, bytes.length:#{bytes.length}"


  # Determine whether the node at the given position is walkable.
  # (Also returns false if the position is outside the grid.)
  # @param {number} x - The x coordinate of the node.
  # @param {number} y - The y coordinate of the node.
  # @return {boolean} - The walkability of the node.
  isWalkableAt : (x, y) ->
    return false if x < 0 or y < 0 or x >= @width or y >= @height # out bound
    index = (y * @width + x)
    bytePos = index >>> 3
    offset = 7 - index % 8
    byte = @bytes[bytePos]
    # NOTE:
    #   1: means blocked, 0: means walkable
    # ty 2013-01-03
    return not Boolean(byte >>> offset & 1)

  # Set whether the node on the given position is walkable.
  # NOTE: throws exception if the coordinate is not inside the grid.
  # @param {number} x - The x coordinate of the node.
  # @param {number} y - The y coordinate of the node.
  # @param {boolean} walkable - Whether the position is walkable.
  setWalkableAt: (x, y, walkable) ->
    return false if x < 0 or y < 0 or x >= @width or y >= @height # out bound
    index = (y * @width + x)
    bytePos = index >>> 3
    offset = 7 - index % 8
    byte = @bytes[bytePos]
    @bytes[bytePos] = byte ^ 1 << offset if walkable isnt @isWalkableAt(x, y)

  # @return {uint[]} each uint present x(high 16 bit) and y(low 16 bit)
  # Get the neighbors of the given node.
  #
  #     offsets      diagonalOffsets:
  #   +---+---+---+    +---+---+---+
  #   |   | 0 |   |    | 0 |   | 1 |
  #   +---+---+---+    +---+---+---+
  #   | 3 |   | 1 |    |   |   |   |
  #   +---+---+---+    +---+---+---+
  #   |   | 2 |   |    | 3 |   | 2 |
  #   +---+---+---+    +---+---+---+
  #
  # When allowDiagonal is true, if offsets[i] is valid, then
  # diagonalOffsets[i] and
  # diagonalOffsets[(i + 1) % 4] is valid.
  # @param {uint}  x
  # @param {uint}  y
  # @param {boolean} allowDiagonal
  # @param {boolean} dontCrossCorners
  # @return {uint[]} a list of walkable neighbors brick loc
  getNeighbors : (x, y, allowDiagonal=false, dontCrossCorners=false) ->
    #console.log  x, y, allowDiagonal, dontCrossCorners
    return null if x < 0 or y < 0 or x >= @width or y >= @height # out bound
    # TODO:
    #   should return null when brick is blocked?
    # ty 2013-05-05

    neighbors = []

    # ↑
    if @isWalkableAt(x, y-1)
      neighbors.push(x << 16 | (y-1))
      s0 = true

    # →
    if @isWalkableAt(x + 1, y)
      neighbors.push((x + 1) << 16 | y)
      s1 = true

    # ↓
    if @isWalkableAt(x, y + 1)
      neighbors.push(x << 16 | (y + 1))
      s2 = true

    # ←
    if @isWalkableAt(x - 1, y)
      neighbors.push((x - 1) << 16 | y)
      s3 = true

    return neighbors unless allowDiagonal

    if dontCrossCorners
      d0 = s3 && s0
      d1 = s0 && s1
      d2 = s1 && s2
      d3 = s2 && s3
    else
      d0 = s3 || s0
      d1 = s0 || s1
      d2 = s1 || s2
      d3 = s2 || s3

    # ↖
    if (d0 && @isWalkableAt(x - 1, y - 1)) then neighbors.push((x - 1) << 16 | (y - 1))

    # ↗
    if (d1 && @isWalkableAt(x + 1, y - 1)) then neighbors.push((x + 1) << 16 | (y - 1))

    # ↘
    if (d2 && @isWalkableAt(x + 1, y + 1)) then neighbors.push((x + 1) << 16 | (y + 1))

    # ↙
    if (d3 && @isWalkableAt(x - 1, y + 1)) then neighbors.push((x - 1) << 16 | (y + 1))

    return neighbors

  # @return {uint} a walkable brick location
  getARandomWalkableBrick : ->
    loop
      x = (Math.random() * @width) >>> 0
      y = (Math.random() * @height) >>> 0
      return x << 16 | y if @isWalkableAt(x,y)


  # print out the block data for human inspection
  # @param {uint} startLoc the start brick loc
  # @param {uint} endLoc the end brick loc
  # @param {uint[]} path array of point
  # @return {String} a string describe this instance
  toString : (startLoc, endLoc, path)->
    markpoints = {}
    if Array.isArray(path)
      for brickLoc, i in path
        markpoints[brickLoc] = i % 10

    markpoints[startLoc] = "S" unless isNaN(startLoc)
    markpoints[endLoc] = "E" unless isNaN(endLoc)

    result = "[Grid(width=#{@width}, height=#{@height})]\nDump: ░=walkable, ▓=blocked"
    for y in [0...@height] by 1
      arr = []
      for x in [0...@width] by 1
        if markpoints[x << 16 | y] isnt undefined
          arr.push(markpoints[x << 16 | y])
        else
          arr.push(if @isWalkableAt(x,y) then "░" else "▓")
      result = result + "\n#{arr.join ''}"
    return result

module.exports = Grid


