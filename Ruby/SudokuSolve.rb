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

game.drawGameBoard()
