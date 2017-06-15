=begin
board = [[0,0,0,0,0,0,0,0],
         [0,0,0,0,0,0,0,0],
         [0,0,0,0,0,0,0,0],
         [0,0,0,0,0,0,0,0],
         [0,0,0,0,0,0,0,0],
         [0,0,0,0,0,0,0,0],
         [0,1,0,0,0,0,2,2]]
turn = 1
=end
#=begin
board = []
7.times do
  board.push gets.chomp.split(' ').map(&:to_i)
end
turn = gets.chomp.to_i
#=end
def chwin board
  if (genall (board)).include?([1,1,1,1])
    winner = 1
  elsif (genall (board)).include?([2,2,2,2])
    winner = 2
  else
    winner = 0
  end
  return winner
end
 
def nicep grid
  grid.each do |line|
    line.each do |item|
      print item
      print ' '
    end
    puts
  end
end
 
def chvalid(board,move)
  return true if board[0][move] == 0
  return false
end
 
def move(board,num,player)
  return [board,nil,nil] unless chvalid(board,num)
  board.each_index do |lineno|
    if board[lineno][num]!= 0
      board[lineno-1][num] = player
      return board,lineno-1,num
    end
  end
  board[6][num] = player
  return board,6,num
end
 
def ordersplit(arr,num)
  num -= 1
  newarr = []
  (0..(arr.length-num-1)).each do |i|
    newarr.push arr[(i..i+num)]
  end
  newarr
end
 
 
def chfiar(board,a,b,player)
  toch = [player,player,player,player]
  return false unless (a != nil and b != nil) and [1,2].include?(board[a][b])
  
  temparr = []
  (0..6).each do |tnum|
    tnum -= 3
    temparr.push board[a][b+tnum] unless b+tnum < 0
  end
  if ordersplit(temparr,4).include?(toch)
    return true 
  end
  
  temparr = []
  (0..6).each do |tnum|
    tnum -= 3
    temparr.push board[a+tnum][b] unless (board[a+tnum] == nil or a+tnum<0)
  end
  if ordersplit(temparr,4).include?(toch)
    return true 
  end
  
  temparr = []
  (0..6).each do |tnum|
    tnum -= 3
    temparr.push board[a+tnum][b+tnum] unless (board[a+tnum] == nil or a+tnum<0 or b+tnum<0)
  end
  if ordersplit(temparr,4).include?(toch)
    return true 
  end
 
  temparr = []
  (0..6).each do |tnum|
    tnum -= 3
    temparr.push board[a+tnum][b-tnum] unless (board[a+tnum] == nil or a+tnum<0 or b-tnum<0)
  end
  if ordersplit(temparr,4).include?(toch)
    return true 
  end
    
  false
end
 
def genall(board)
  allsets = []
  cols = [[],[],[],[],[],[],[],[]]
  diagb = [[],[],[],[],[],[],[],[],[],[],[],[],[],[]]
  diagf = [[],[],[],[],[],[],[],[],[],[],[],[],[],[]]
  count = 0
  board.each_index do |lineno|
    ordersplit(board[lineno],4).each {|a| allsets.push a}
    board[lineno].each_index do |colno|
      item = board[lineno][colno]
      cols[colno].push item
      diagf[lineno+colno].push item
      diagb[lineno-colno+7].push item
    end
  end
  count = 1
  cols.each do |col|
    ordersplit(col,4).each {|a| allsets.push a}
  end
  diagb.each do |diag|
    next if diag.length < 4
    count += ordersplit(diag,4).length
    ordersplit(diag,4).each {|a| allsets.push a}
  end
  diagf.each do |diag|
    next if diag.length < 4
    count += ordersplit(diag,4).length
    ordersplit(diag,4).each {|a| allsets.push a}
  end
  allsets
end
 
def chnum all,num,obj
  all.each do |one|
#    if obj == 2
#      p one
#      p one.count(obj)
#      gets
#    end
    if one.count(obj) == num
      return true
    end
  end
  false
end
  
def must(board,player)
  if chnum(genall(board),3,player)
    (0..7).each do |num|
      newboard = move(Marshal.load(Marshal.dump(board)),num,player)[0]
      if chnum((genall(newboard)),4,player)
        return num
      end
    end
  end
  if chnum((genall(board)),3,(3-player))
    (0..7).each do |num|
      newboard = move(Marshal.load(Marshal.dump(board)),num,3-player)[0]
      if chnum((genall(newboard)),4,3-player)
        return num
      end
    end
  end
  -1
end
 
def stupidcheck(board,player,possmove)
  return false unless chvalid(board,possmove)
  newboard = move(Marshal.load(Marshal.dump(board)),possmove,player)[0]
  (0..7).each do |oppmove|
    next unless chvalid(newboard,oppmove)
    nextnew = move(Marshal.load(Marshal.dump(newboard)),oppmove,3-player)
    if chwin(nextnew[0]) != 0
#      nicep nextnew[0] if possmove == 0
#      p oppmove if possmove == 0
#      gets
      return true
    end
  end
  false
end
 
def evaluatem(board,player)
  score = 0
  allsets = genall(board)
  allsets.each do |set|
    if set.count(player) == 4
      score += 1000000000000
#      nicep board
#      gets
    elsif set.count(player) == 3 and set.count(0) == 1
      score += 81
    elsif set.count(player) == 2 and set.count(0) == 2
      score += 16
    elsif set.count(player) == 1 and set.count(0) == 3
      score += 1
    elsif set.count(3-player) == 1 and set.count(0) == 3
      score -= 1
    elsif set.count(3-player) == 2 and set.count(0) == 2
      score -= 16
    elsif set.count(3-player) == 3 and set.count(0) == 1
      score -= 81
    elsif set.count(3-player) == 4
      score -= 1000000000000
    end
  end
  score
end
 
def play(board,player)
  moves = {}
  (0..7).each do |poss|
#    p poss
#    p stupidcheck(board,player,poss)
    stpd = stupidcheck(board,player,poss)
    if chvalid(board,poss) and (!stpd)
      mustmove = must(board,player)
      if mustmove>=0 and mustmove == poss
        puts mustmove
        puts 'hi'
        exit
      end
#      puts poss
      newboard = move(Marshal.load(Marshal.dump(board)),poss,player)
      moves[poss] = alphabeta(newboard[0],3-player,4,-1.0/0.0,1.0/0.0,newboard[1],newboard[2])
    elsif chvalid(board,poss) and stpd
      mustmove = must(board,player)
      if mustmove > -1 and mustmove == poss
        puts mustmove
        puts 'im dead'
        exit
      end
      moves[poss] = -1.0/0.0
    end
  end
  best = moves.values.max
  goodmoves = []
  moves.each do |k,v|
    goodmoves.push k if v == best
  end
#  p moves
  return goodmoves[rand(goodmoves.length)]
end
 
def alphabeta(board,player,depth,a,b,l,m)
#  p depth.to_s + "Depth"
  if depth == 0
    return evaluatem(board,3-player).to_f
  elsif chfiar(board,l,m,3-player)
#    puts "HI"
    return evaluatem(board,player).to_f
  end
  if player == 1
    v = -1.0/0.0
    (0..7).each do |poss|
      newboard = move(Marshal.load(Marshal.dump(board)),poss,player)
      v = [v,alphabeta(newboard[0],3-player,depth-1,a,b,newboard[1],newboard[2])].reject(&:nan?).max
#      p [a,v]
      a = [a,v].max
      break if b <= a
    end
    return v
  else
    v = 1.0/0.0
    (0..7).each do |poss|
      newboard = move(Marshal.load(Marshal.dump(board)),poss,player)
      v = [v,alphabeta(newboard[0],3-player,depth-1,a,b,newboard[1],newboard[2])].reject(&:nan?).min
      b = [b,v].min
      break if b <= a
    end
    return v
  end
end
 
#puts genall(board).length
 
puts play(board,turn)
