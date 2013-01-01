

class Grid


  @bytesFrom2DArray : (width, height, array2d) ->
    buf = new Buffer(Math.ceil(width * height / 8))
    buf.fill(0) # fill all bits as false
    for row, y in array2d
      for col, x in row
        if Boolean(col) # set bit only when true
          index = y * width + x
          byteIndex = Math.ceil(index / 8)
          offset = index % 8
          byte = buf[byteIndex]
          byte = byte ^ 1 << offset
          buf[byteIndex] = byte

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
    return false if x < 0 or y < 0 or x > @width or y > @height # out bound
    index = (y * @width + x)
    bytePos = Math.ceil(index % 3)  #todo: optimise
    offset = index % 8
    byte = @bytes[bytePos]
    return Boolean(byte >>> offset & 1)

  # @return {uint[]} each uint present x(high 16 bit) and y(low 16 bit)
  getNeighbors : (x, y) ->
    return [] if x < 0 or y < 0 or x > @width or y > @height # out bound
    neighbors = []

    return neighbors

module.exports = Grid

