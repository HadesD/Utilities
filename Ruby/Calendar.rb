require 'date'

# Settings
$maxColumn = 3
$birth = {
  "day" => 20,
  "month" => 3
}

def calendar(year, month)
  day = Date.new(year, month, 1)
  startPos = day.wday
  lastDay = Date.new(year, month, -1).day
  
  rs = [
    ["\t", "\t", "\t", "#{month}月\t", "\t", "\t", "\t"],
    ["日\t","月\t","火\t", "水\t", "木\t","金\t","土\t"]
  ]
  line = []
  startPos.times do
    line.push("\t")
  end
  
  for i in 1..lastDay do
    day = i
    if ((month == $birth["month"]) && (day == $birth["day"])) then
      day = "*#{i}*"
    end
    line.push("#{day}\t")
    tempDay = Date.new(year, month, i)
    if tempDay.wday == 6 then
      rs.push(line)
      line = []
    end
  end
  lastWDay = Date.new(year, month, lastDay).wday
  while (lastWDay < 6) do
    line.push("\t")
    lastWDay += 1
  end
  rs.push(line)
  if rs.count < 8 then
    rs.push(["\t", "\t", "\t", "\t", "\t", "\t", "\t"])
  end
  return rs
end

def calendar_year(year)
  # General var:
  month = 12
  cols = $maxColumn # Month 's columns
  rows = month / cols # Month 's rows
  
  startM = 1
  for curRow in 1..rows do
    maxOff = startM + cols - 1
    for i in 0..7 do
      for curM in startM..maxOff do
        argsM = calendar(year, curM)[i]
        for curR in 0..argsM.count do
          print argsM[curR]
        end
      end
      puts
    end
    startM = curRow * cols + 1
    puts
  end
end

# Write console
calendar_year(2017)
