game_grid = [
  "003020600900305001001806400008102900700000008006708200002609500800203009005010300", # Easy
  "4.....8.5.3..........7......2.....6.....8.4......1.......6.3.7.5..2.....1.4......", # Easy
  ".....6....59.....82....8....45........3........6..3.54...325..6.................." # Hard
]

class Game
  def initialize
    @game_board = []
    for x in (0..8) do
      col = []
      for y in (0..8) do
        col.push(0)
      end
      @game_board.push(col)
    end
  end
  
  def setGameBoardByGrid(grid)
    raise grid unless 81
    
    @game_board.each_with_index do | gbX, x |
      gbX.each_with_index do | gbY, y |
        @game_board[x][y] = grid[x * 9 + y]
      end
    end
  end
  
  def drawGameBoard()
    break_line = -> (x) { 
      if ((x != 0) && ((x % 3) == 0)) then
      for i in (0..30) do
        if (i % 10 == 0) then
          print "+"
        else
          print '-'
        end
      end
      puts
    end
    }
    @game_board.each_with_index do | gbX, x |
      break_line.call(x)
      gbX.each_with_index do | gbY, y |
        if (y == 0)
          print "|"
        end
        print " ", gbY, " "
        if ((y+1) % 3 == 0) then
          print "|"
        end
      end
      puts
    end
  end
  
  def getGameBoard()
    return @game_board
  end
end

game = Game.new

game.setGameBoardByGrid(game_grid[0])

game.drawGameBoard()
