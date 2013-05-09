class Heap

  constructor: (@locToF) ->
    @nodes = []

  isNotEmpty: ->
    return @nodes.length > 0

  _siftdown : (startPos, pos) ->
    #console.log "[heap::_siftdown] startPos:#{startPos}, pos:#{pos}"

    newNode = @nodes[pos]
    while (pos > startPos)
      parentpos = (pos - 1) >>> 1
      parentNode = @nodes[parentpos]
      if (@locToF[newNode] < @locToF[parentNode])
        @nodes[pos] = parentNode
        pos = parentpos
        continue
      break #TODO: need double check
    @nodes[pos] = newNode

    return

  _siftup : (pos) ->
    #console.log "[heap::_siftup] pos:#{pos}"
    endPos = @nodes.length
    startPos = pos
    newNode = @nodes[pos]
    childPos = (pos << 1) + 1
    while (childPos < endPos)
      rightPos = childPos + 1
      childPos = rightPos if (rightPos < endPos && (@locToF[@nodes[childPos]] > @locToF[@nodes[rightPos]]))
      @nodes[pos] = @nodes[childPos]
      pos = childPos
      childPos = (pos << 1) + 1

    @nodes[pos] = newNode
    @_siftdown(startPos , pos)

    return

  updateItem : (node) ->
    #console.log "[heap::updateItem] node:#{node}"
    pos = @nodes.indexOf(node)
    return if (pos < 0)
    @_siftdown(0 , pos)
    @_siftup(pos)
    return


  # Push item onto heap, maintaining the heap invariant.
  # @param {uint} node
  push : (node) ->
    #console.log "[heap::push] node:#{node}"
    @nodes.push(node)
    @_siftdown(0 , @nodes.length - 1)

  # Pop the smallest item off the heap, maintaining the heap invariant.
  # @return {uint}
  pop : ->
    #console.log "[heap::pop]"
    lastelt = @nodes.pop()
    if(@nodes.length)
      returnitem = @nodes[0]
      @nodes[0] = lastelt
      @_siftup(0)
    else
      return lastelt
    return returnitem

  # reset the heap
  # @param {Object} locToF, a key-value hash
  reset : (locToF) ->
    #console.log "[heap::reset] locToF:#{locToF}"
    @nodes.length = 0
    @locToF = locToF
    return


module.exports = Heap


