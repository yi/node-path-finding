grid = require "../grid"


describe "Static method in Grid", ->

  it "should work" , ->

    array2d = [
      [1, 0, 0],
      [0, 1, 0],
      [0, 0, 1],
      [1, 1, 0],
      [1, 0, 0]
    ]

    width = 3

    height = 5

    buf = grid.bytesFrom2DArray(width, height, array2d)

    console.log(buf.toString('hex'))

    for i in [0...buf.length]
      console.log "[grid_test] buf[i]:#{buf[i].toString(2)}"



    #dump = ''

    #for y in [0...height] by 1
      #for x in [0...width] by 1





