game_grid = [
  "003020600900305001001806400008102900700000008006708200002609500800203009005010300", # Easy
  "400000805030000000000700000020000060000080400000010000000603070500200000104000000", # Hard
  "000031200000200000603008400208000040400050001070000908009300602000009000002510000", # Normal
  "001200030002401005640300000716000040000000000020000861000003078300804100090005300", # Normal
  "010000020340000056000206000007628500000507000006934200000405000560000084070000010", # Easy
  "000000000010234050002000400060703020040000080050609030006000500030862040000000000" # Hard
]

class Game
  def initialize
    @game_grid
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
    
  def solve()
    num_index = @game_grid.index('0')
    return true unless num_index
    ('1'..'9').each do |possibility|
      @game_grid[num_index] = possibility
      return @game_grid if (board_check(num_index)) && solve()
    end
    @game_grid[num_index] = '0'
    false
  end

  def board_check(n_index)
    n = @game_grid[n_index]
    return false unless check_row(n, n_index)
    return false unless check_col(n, n_index)
    return false unless check_box(n, n_index)
    true
  end

  def setGameBoardByGrid(grid)
    @game_grid = grid
    @game_board.each_with_index do | gbX, x |
      gbX.each_with_index do | gbY, y |
        @game_board[x][y] = @game_grid[x * 9 + y]
      end
    end
  end

  def check_row(n, n_index)
    row = n_index / 9
    start = row * 9
    (start..(start + 8)).each do |check_i|
      return false unless check(check_i, n, n_index)
    end
    true
  end

  def check_col(n, n_index)
    col = n_index%9
    start = 0
    (1..9).each do |x|
      check_i = start + col
      return false unless check(check_i, n, n_index)
      start += 9
    end
    true
  end

  def check_box(n, n_index)
    col_start, row_start = (((n_index%9)/3) * 3), ((n_index/27) * 27)
    3.times do
      (col_start..(col_start+2)).each do |col|
        return false unless check(col + row_start, n, n_index)
      end
      row_start += 9
    end
  end

  def check(index, n, n_index)
    if ((n == @game_grid[index]) && (index != n_index))
      return false
    else
      return true
    end
  end
end

game = Game.new

game.setGameBoardByGrid(game_grid[5])

game.drawGameBoard()

p "Calculating..."

solved = game.solve()
if (solved)
  game.setGameBoardByGrid(solved)
  game.drawGameBoard()
else
  p "Can not solve this game"
end
 
