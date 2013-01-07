

class Grid


  @bytesFrom2DArray : (width, height, array2d) ->
    buf = new Buffer(Math.ceil(width * height / 8))
    console.log "len:#{buf.length}"
    buf.fill(0) # fill all bits as false

    for row, y in array2d
      for col, x in row
        unless Boolean(col) # set bit only when true
          index = y * width + x
          byteIndex = index >>> 3
          offset = 7 - (index % 8) #从高位向低位写
          byte = buf[byteIndex]
          byte = byte ^ 1 << offset
          buf[byteIndex] = byte
          console.log "walkable at row:#{y}, col:#{x}, row:#{row}, index:#{index}, offset:#{offset}, byteIndex:#{byteIndex}"
    return buf


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
#   When allowDiagonal is true, if offsets[i] is valid, then
#   diagonalOffsets[i] and
#   diagonalOffsets[(i + 1) % 4] is valid.
#  @param {uint}  x
#  @param {uint}  y
#  @param {boolean} allowDiagonal
#  @param {boolean} dontCrossCorners
  # @return {uint[]} a list of walkable neighbors brick loc
  getNeighbors : (x, y, allowDiagonal=true, dontCrossCorners=false) ->
    #console.log  x, y, allowDiagonal, dontCrossCorners
    return [] if x < 0 or y < 0 or x >= @width or y >= @height # out bound
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



  # print out the block data for human inspection
  # @return {String} a string describe this instance
  toString : ->
    result = "[Grid(width=#{@width}, height=#{@height})]\nDump: 1=walkable, 0=blocked"
    for y in [0...@height] by 1
      arr = []
      for x in [0...@width] by 1
        arr.push Number(@isWalkableAt(x,y))
      result = result + "\n#{arr.join ''}"
    return result

module.exports = Grid


