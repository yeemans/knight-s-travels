
class Node 
  attr_accessor :current, :possibilities, :destination, :parent
  def initialize(current, possibilities, destination, parent) 
    # current is the square the knight is on 
    @current = current
    # possibilities is an array containing square coordinates that can be moved to from this location
    @possibilities = possibilities 
    # destination is the square in the end to go to 
    @destination = destination
    # parent is the square that the knight stood on before going to said square 
    @parent = parent
 
  end
end
def knights_moves(source, destination)
  #board is 0 indexed
  if source[0] > 7 || source[0] < 0 || source[1] > 7 || source[1] < 0 ||
    destination[0] > 7 || destination[0] < 0 || destination[1] > 7 || destination[1] < 0
    p "invalid coordinates"
    return 
  end 
  row = source[1] 
  col = source[0]
  knight = Node.new(source, [], destination, nil) # as the first square, it has no parent
  p knight.possibilities
  #number of moves
  moves = 0

  traversed = []
  def build_tree(knight, row, col)
    if row + 2 <= 7 && col + 1 <= 7 # top right 
      if [col + 1, row + 2] != knight.current
        move = [col + 1, row + 2]
        knight.possibilities.push(Node.new(move, [], nil, knight))
      end
    end

    if row + 2 <= 7 && col - 1 >= 0 # top left
      move = [col - 1, row + 2]
      knight.possibilities.push(Node.new(move, [], nil, knight))
    end

   # squares that are one unit above the spot knight stands on 
    if row + 1 <= 7 && col + 2 <= 7 #to the right 
      move = [col + 2, row + 1]
      knight.possibilities.push(Node.new(move, [], nil, knight))
    end 

    if row + 1 <= 7 && col - 2 >= 0 
      move = [col - 2, row + 1]
      knight.possibilities.push(Node.new(move, [], nil, knight))
    end 

    # squares that are one unit under the knight

    if row - 1 >= 0 && col + 2 <= 7 
      move = [col + 2, row - 1]
      knight.possibilities.push(Node.new(move, [], nil, knight))
    end 

    if row - 1 >= 0 && col - 2 >= 0 
      move = [col - 2, row - 1]
      knight.possibilities.push(Node.new(move, [], nil, knight))
    end 

  # sqaures two units under the knight 
  
    if row - 2 >= 0 && col + 1 <= 7 
      move = [col + 1, row - 2]
      knight.possibilities.push(Node.new(move, [], nil, knight))
    end 

    if row - 2 >= 0 && col - 1 >= 0 
      move = [col - 1, row - 2]
      knight.possibilities.push(Node.new(move, [], nil, knight))
    end
    # removing knight's current square from each array in possibilties
    return knight.possibilities
  end

  # building the knight's possible move trees 
  knight.possibilities = build_tree(knight, row, col)
  # build first level


  knight.possibilities.each do |possibility| 
    possibility.possibilities = build_tree(possibility, possibility.current[1], possibility.current[0])
    possibility.possibilities = possibility.possibilities.uniq
    moves += 1
     #build second level 
    possibility.possibilities.each do |second| 
      second.possibilities = build_tree(second, second.current[1], second.current[0])
      second.possibilities = second.possibilities.uniq
      moves += 1
    # build third level 
      second.possibilities.each do |third| 
        moves += 1
        third.possibilities = build_tree(third, third.current[1], third.current[0])
        third.possibilities = third.possibilities.uniq
        # build fourth level
        third.possibilities.each do |fourth| 
          moves += 1
          fourth.possibilities = build_tree(fourth, fourth.current[1], fourth.current[0])
          fourth.possibilities = fourth.possibilities.uniq
         #  build fifth 
          fourth.possibilities.each do |fifth| 
            moves += 1
            fifth.possibilities = build_tree(fifth, fifth.current[1], fifth.current[0])
            fifth.possibilities = fifth.possibilities.uniq
            # build sixth and final level 
            fifth.possibilities.each do |sixth| 
              moves += 1 
              sixth.possibilities = build_tree(sixth, sixth.current[1], sixth.current[0])
              sixth.possibilities = sixth.possibilities.uniq   
              last = sixth.possibilities[sixth.possibilities.count - 1]
            end
          end
        end
      end
    end
  end
  
# breadth first traverse the stupid ass tree 
  def solve(start)
    queue = [start]
    visited = []
    prev = []

    # push each square in neighbors to the queue
    # visited is an array of nodes that have already been visited 
    # prev is previous, and used to reconstruct path later on 
    while !queue.empty?
      neighbors = queue[0].possibilities
      queue.shift()
      neighbors.each do |square| 
        if !visited.include?(square.current)
          queue.push(square)
          visited.push(square)
          visited.push(square.current)
          prev.push(square)
        end
      end
    end 

    return prev

  end

  prev = solve(knight)

  # testing behavior to see if the parent values work correctly
  def reconstructPath(knight, prev)
    # go to the destination 
    # access destination's parent, add parent to queue 
    # repeat 
    path = []
    index = 0 
    while prev[index].current != knight.destination 
      #p prev[index].current
      index += 1
    end
    cursor = prev[index] # cursor of which node you are on
    if knight.current == knight.destination 
      return [knight.destination]
    end
    while cursor.current != knight.current
      path.push(cursor.current)
      cursor = cursor.parent 
    end 
    return path.reverse().unshift(knight.current)
  end

  p "You made it in #{reconstructPath(knight, prev).count - 1} moves! Here's your path: "
  reconstructPath(knight, prev).each do |move| 
    p move 
  end
end


knights_moves([3,3], [4,5])
