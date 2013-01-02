Grid = require "../grid"



array2d = [
  [1, 0, 0],
  [0, 1, 0],
  [0, 0, 1],
  [1, 1, 0],
  [1, 0, 0]
]

width = 3

height = 5

buf = Grid.bytesFrom2DArray(width, height, array2d)

grid = new Grid(width, height, buf)

console.log "grid: #{grid}"



describe "Static method in Grid", ->

  it "should work" , ->

    for i in [0...buf.length] by 1
      console.log "[grid_test] buf[i]:#{buf[i].toString(2)}"

    return

    #dump = ''

    #for y in [0...height] by 1
      #for x in [0...width] by 1





