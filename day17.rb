#!/usr/bin/env ruby

require 'pry'

DATA = "1,330,331,332,109,6690,1102,1,1182,16,1102,1,1505,24,102,1,0,570,1006,570,36,1002,571,1,0,1001,570,-1,570,1001,24,1,24,1106,0,18,1008,571,0,571,1001,16,1,16,1008,16,1505,570,1006,570,14,21102,58,1,0,1105,1,786,1006,332,62,99,21101,333,0,1,21102,73,1,0,1105,1,579,1102,0,1,572,1101,0,0,573,3,574,101,1,573,573,1007,574,65,570,1005,570,151,107,67,574,570,1005,570,151,1001,574,-64,574,1002,574,-1,574,1001,572,1,572,1007,572,11,570,1006,570,165,101,1182,572,127,1002,574,1,0,3,574,101,1,573,573,1008,574,10,570,1005,570,189,1008,574,44,570,1006,570,158,1106,0,81,21101,340,0,1,1106,0,177,21102,1,477,1,1106,0,177,21101,0,514,1,21102,1,176,0,1106,0,579,99,21101,0,184,0,1105,1,579,4,574,104,10,99,1007,573,22,570,1006,570,165,1001,572,0,1182,21101,375,0,1,21102,211,1,0,1106,0,579,21101,1182,11,1,21101,222,0,0,1105,1,979,21101,388,0,1,21101,0,233,0,1105,1,579,21101,1182,22,1,21102,1,244,0,1105,1,979,21101,401,0,1,21101,255,0,0,1105,1,579,21101,1182,33,1,21101,0,266,0,1105,1,979,21101,0,414,1,21101,277,0,0,1106,0,579,3,575,1008,575,89,570,1008,575,121,575,1,575,570,575,3,574,1008,574,10,570,1006,570,291,104,10,21101,1182,0,1,21102,1,313,0,1106,0,622,1005,575,327,1101,0,1,575,21101,327,0,0,1106,0,786,4,438,99,0,1,1,6,77,97,105,110,58,10,33,10,69,120,112,101,99,116,101,100,32,102,117,110,99,116,105,111,110,32,110,97,109,101,32,98,117,116,32,103,111,116,58,32,0,12,70,117,110,99,116,105,111,110,32,65,58,10,12,70,117,110,99,116,105,111,110,32,66,58,10,12,70,117,110,99,116,105,111,110,32,67,58,10,23,67,111,110,116,105,110,117,111,117,115,32,118,105,100,101,111,32,102,101,101,100,63,10,0,37,10,69,120,112,101,99,116,101,100,32,82,44,32,76,44,32,111,114,32,100,105,115,116,97,110,99,101,32,98,117,116,32,103,111,116,58,32,36,10,69,120,112,101,99,116,101,100,32,99,111,109,109,97,32,111,114,32,110,101,119,108,105,110,101,32,98,117,116,32,103,111,116,58,32,43,10,68,101,102,105,110,105,116,105,111,110,115,32,109,97,121,32,98,101,32,97,116,32,109,111,115,116,32,50,48,32,99,104,97,114,97,99,116,101,114,115,33,10,94,62,118,60,0,1,0,-1,-1,0,1,0,0,0,0,0,0,1,84,18,0,109,4,2101,0,-3,587,20102,1,0,-1,22101,1,-3,-3,21102,1,0,-2,2208,-2,-1,570,1005,570,617,2201,-3,-2,609,4,0,21201,-2,1,-2,1106,0,597,109,-4,2106,0,0,109,5,2102,1,-4,629,21001,0,0,-2,22101,1,-4,-4,21102,1,0,-3,2208,-3,-2,570,1005,570,781,2201,-4,-3,652,21001,0,0,-1,1208,-1,-4,570,1005,570,709,1208,-1,-5,570,1005,570,734,1207,-1,0,570,1005,570,759,1206,-1,774,1001,578,562,684,1,0,576,576,1001,578,566,692,1,0,577,577,21101,702,0,0,1106,0,786,21201,-1,-1,-1,1106,0,676,1001,578,1,578,1008,578,4,570,1006,570,724,1001,578,-4,578,21101,0,731,0,1106,0,786,1105,1,774,1001,578,-1,578,1008,578,-1,570,1006,570,749,1001,578,4,578,21102,756,1,0,1106,0,786,1106,0,774,21202,-1,-11,1,22101,1182,1,1,21102,1,774,0,1106,0,622,21201,-3,1,-3,1105,1,640,109,-5,2105,1,0,109,7,1005,575,802,20101,0,576,-6,21002,577,1,-5,1106,0,814,21102,0,1,-1,21102,0,1,-5,21102,1,0,-6,20208,-6,576,-2,208,-5,577,570,22002,570,-2,-2,21202,-5,85,-3,22201,-6,-3,-3,22101,1505,-3,-3,1201,-3,0,843,1005,0,863,21202,-2,42,-4,22101,46,-4,-4,1206,-2,924,21101,0,1,-1,1105,1,924,1205,-2,873,21101,0,35,-4,1105,1,924,2101,0,-3,878,1008,0,1,570,1006,570,916,1001,374,1,374,2102,1,-3,895,1102,1,2,0,2101,0,-3,902,1001,438,0,438,2202,-6,-5,570,1,570,374,570,1,570,438,438,1001,578,558,922,20101,0,0,-4,1006,575,959,204,-4,22101,1,-6,-6,1208,-6,85,570,1006,570,814,104,10,22101,1,-5,-5,1208,-5,61,570,1006,570,810,104,10,1206,-1,974,99,1206,-1,974,1101,0,1,575,21102,973,1,0,1105,1,786,99,109,-7,2106,0,0,109,6,21101,0,0,-4,21102,0,1,-3,203,-2,22101,1,-3,-3,21208,-2,82,-1,1205,-1,1030,21208,-2,76,-1,1205,-1,1037,21207,-2,48,-1,1205,-1,1124,22107,57,-2,-1,1205,-1,1124,21201,-2,-48,-2,1106,0,1041,21101,0,-4,-2,1105,1,1041,21101,0,-5,-2,21201,-4,1,-4,21207,-4,11,-1,1206,-1,1138,2201,-5,-4,1059,2101,0,-2,0,203,-2,22101,1,-3,-3,21207,-2,48,-1,1205,-1,1107,22107,57,-2,-1,1205,-1,1107,21201,-2,-48,-2,2201,-5,-4,1090,20102,10,0,-1,22201,-2,-1,-2,2201,-5,-4,1103,1202,-2,1,0,1105,1,1060,21208,-2,10,-1,1205,-1,1162,21208,-2,44,-1,1206,-1,1131,1106,0,989,21101,0,439,1,1106,0,1150,21102,477,1,1,1106,0,1150,21101,0,514,1,21101,1149,0,0,1106,0,579,99,21101,0,1157,0,1105,1,579,204,-2,104,10,99,21207,-3,22,-1,1206,-1,1138,1202,-5,1,1176,1202,-4,1,0,109,-6,2106,0,0,46,7,78,1,84,1,84,1,84,1,84,1,80,13,72,1,3,1,7,1,72,1,3,1,7,1,9,11,52,1,3,1,7,1,9,1,9,1,52,1,3,1,7,1,9,1,9,1,52,1,3,1,7,1,9,1,9,1,44,13,7,1,9,1,9,1,44,1,7,1,11,1,9,1,9,1,44,1,7,1,11,1,9,1,9,1,44,1,7,1,11,1,9,1,9,1,42,11,11,1,9,1,9,1,42,1,1,1,19,1,9,1,9,1,42,1,1,1,19,11,9,11,32,1,1,1,82,1,1,1,82,1,1,1,82,1,1,1,82,1,1,1,72,13,72,1,9,1,74,1,9,11,64,1,19,1,64,1,19,1,64,1,19,1,64,1,19,1,64,1,19,1,64,1,19,1,64,1,19,1,64,11,9,1,74,1,9,1,72,13,72,1,1,1,82,1,1,1,82,1,1,1,82,1,1,1,82,1,1,1,52,11,19,1,1,1,52,1,9,1,19,1,1,1,52,1,9,1,11,11,52,1,9,1,11,1,7,1,54,1,9,1,11,1,7,1,54,1,9,1,11,1,7,1,54,13,5,13,64,1,1,1,5,1,3,1,72,1,1,1,5,1,3,1,72,1,1,1,5,1,3,1,72,1,1,1,5,1,3,1,72,1,1,1,5,1,3,1,72,13,74,1,5,1,78,1,5,1,78,1,5,1,78,1,5,1,78,1,5,1,78,7,66"
input = DATA.split(',').map(&:to_i)
input_copy = input.dup

def debug(s)
  puts s if ENV['DEBUG']
end

def debug2(s)
  puts s if ENV['DEBUG2']
  STDOUT.flush
end

def read_param(param_mode, input, index, relative_base)
  case param_mode
  when 0 # position mode
    debug "Reading param at index #{index} in position mode, points to index #{input[index]}, value #{input[input[index]]}"
    input[input[index]]
  when 1
    debug "Reading param at index #{index} in immediate mode, value #{input[index]}"
    input[index]
  when 2
    debug "Reading param at index #{index} in relative mode, points to index #{input[relative_base + input[index]]}, value #{input[input[relative_base + input[index]]]}"
    input[relative_base + input[index]]
  else
    raise "Unknown param_mode #{param_mode}"
  end
end

def write_param(param_mode, input, index, relative_base, value)
  case param_mode
  when 0
    debug "Writing value #{value} in position mode at index #{index}, points to index #{input[index]}, previous value #{input[input[index]]}"
    input[input[index]] = value
  when 1
    raise "Cannot use immediate mode to write!"
  when 2
    debug "Writing value #{value} in relative mode at index #{index}, points to index #{input[index] + relative_base}, previous value #{input[input[index] + relative_base]}"
    input[input[index] + relative_base] = value
  else
    raise "Unknown param_mode #{param_mode} to write param"
  end
end

def read_next(input, index, intake)
  puts input[index..(index + intake - 1)].join(' ') if ENV['DEBUG']
end

def step(index, input, params)
  relative_base = params[:relative_base]
  stdin = params[:stdin]
  stdout = params[:stdout]
  opcode = input[index] % 100
  modes = (input[index] / 100).digits + [0] * 3 # extend modes with enough 0s
  read_next(input, index, 8)
  print "Opcode is #{opcode} " if ENV['DEBUG']
  case opcode
  when 1
    debug 'addition'

    old_value = input[input[index + 3]]
    value = read_param(modes[0], input, index + 1, relative_base) + read_param(modes[1], input, index + 2, relative_base)
    write_param(modes[2], input, index+3, relative_base, value)
    # puts input.join(",") if ENV['DEBUG']
    4
  when 2
    debug 'multiplication'

    value = read_param(modes[0], input, index + 1, relative_base) * read_param(modes[1], input, index + 2, relative_base)
    write_param(modes[2], input, index+3, relative_base, value)
    # puts input.join(",") if ENV['DEBUG']
    4
  when 3
    debug 'stdin'
    raise 'Already consumed stdin' if stdin.empty? && stdin.is_a?(Array)

    old_value = input[input[index + 1]]
    write_param(modes[0], input, index+1, relative_base, stdin.pop)
    # puts input.join(",") if ENV['DEBUG']
    2
  when 4
    debug 'stdout'
    stdout << read_param(modes[0], input, index + 1, relative_base)
    #debug "STDOUT: #{stdout.join(',')}"
    2
  when 5
    debug 'jump-if-true'
    if read_param(modes[0], input, index + 1, relative_base) != 0
      puts "Jumping to #{read_param(modes[1], input, index + 2, relative_base)}" if ENV['DEBUG']
      # puts input.join(",") if ENV['DEBUG']
      read_param(modes[1], input, index + 2, relative_base) - index
    else
      puts 'Not jumping' if ENV['DEBUG']
      3
    end
  when 6
    debug 'jump-if-false'
    if read_param(modes[0], input, index + 1, relative_base) == 0
      puts "Jumping to #{read_param(modes[1], input, index + 2, relative_base)}" if ENV['DEBUG']
      # puts input.join(",") if ENV['DEBUG']
      read_param(modes[1], input, index + 2, relative_base) - index
    else
      puts 'Not jumping' if ENV['DEBUG']
      3
    end
  when 7
    debug 'lower-than'

    a = read_param(modes[0], input, index + 1, relative_base)
    b = read_param(modes[1], input, index + 2, relative_base)
    value = a < b ? 1 : 0
    write_param(modes[2], input, index+3, relative_base, value)
    # puts input.join(",") if ENV['DEBUG']
    # puts input.join(",") if ENV['DEBUG']
    4
  when 8
    debug 'equal'

    a = read_param(modes[0], input, index + 1, relative_base)
    b = read_param(modes[1], input, index + 2, relative_base)
    value = a == b ? 1 : 0
    write_param(modes[2], input, index+3, relative_base, value)
    # puts input.join(",") if ENV['DEBUG']
    4
  when 9
    debug 'change of relative base offset'

    params[:relative_base] += read_param(modes[0], input, index + 1, relative_base)
    2
  when 99
    debug 'Halt!' if ENV['DEBUG']
    # puts input.join(",") if ENV['DEBUG']
    debug2 "Halt!!"
    false
  else
    raise "Error with unknown opcode #{opcode} at #{index}"
  end
end

class ExtensibleArray
  def initialize(array)
    @h = {}
    array.each_with_index do |el,index|
      @h[index] = el
    end
  end

  def [](a)
    case a
    when Integer
    if @h.key?(a)
      @h[a]
    else
      0
    end
    when Range
      (a.begin..a.end).map { |i| self[i] }
    else
      raise "Unknown input type for ExtensibleArray"
    end
  end

  def []=(a,b)
    @h[a] = b
  end
end

def iterate(input, stdin: [], stdout: [])
  params = { stdin: stdin, stdout: stdout, relative_base: 0 }
  # puts input.join(",") if ENV['DEBUG']
  i = 0
  increment = 0
  input = ExtensibleArray.new(input)
  while (increment = step(i, input, params))
    puts "Moving cursor from #{i} to #{i + increment}" if ENV['DEBUG']
    i += increment
  end
  input
end

class InOut
  attr_reader :part2

  def initialize
    @view = []
  end

  def <<(el)
    if @part2
      @part2 = el
    else
      @view << el
    end
  end


  def pop
    if @pop_input.nil?
      print_view if ENV['DEBUG2']
      p = path
      initial = contract(p).split(',')
      a, b, c = toto(initial)
      main = compress(initial, a, b,c)
      @pop_input = []
      @pop_input += main.chars.map(&:ord)
      @pop_input << 10
      @pop_input += a.join(',').chars.map(&:ord)
      @pop_input << 10
      @pop_input += b.join(',').chars.map(&:ord)
      @pop_input << 10
      @pop_input += c.join(',').chars.map(&:ord)
      @pop_input << 10
      @pop_input << 'n'.ord
      @pop_input << 10
      debug2 main
      debug2 a.join(',')
      debug2  b.join(',')
      debug2 c.join(',')
      @part2 = true
    end
    @pop_input.shift
  end

  def empty?
    false
  end

  def compress(array, a, b,c)
    array.join(',')
      .gsub(a.join(','), 'A')
      .gsub(b.join(','), 'B')
      .gsub(c.join(','), 'C')
  end

  def contract(p)
    p.inject do |mem, el|
      # mem is always at least 1 el
      mem = Array(mem)
      if Integer === mem.last && el == 1
        mem[0..-2] + [mem.last + 1]
      else
        mem + [el]
      end
    end.join(',').gsub('L,L,L', 'R')
  end

  def reduction(array, sub, replacement)
    array.join(',').gsub(sub.join(','), replacement).split(',')
  end

  def terminal?(array, sub, replacement)
    reduction(array, sub, replacement).all? { |l| %w[A B C].include?(l) }
  end

  def toto(array, level: 0)
    candidates = []
    i = 0
    while %w[A B C].include?(array[i])
      i+=1
    end
    array_trunc = array.drop(i)
    i=0
    while array_trunc.take(i+1).join(',').size <= 20 && i < array_trunc.size && !%w[A B C].include?(array_trunc[i])
      candidates << array_trunc.take(i+1)
      i += 1
    end
    candidates.reverse!
    replacement = (65 + level).chr
    #puts(" " * level + "Testing #{candidates.size} candidates on level #{level} to find #{replacement}")
    candidates.each_with_index do |candidate, index|
      #puts(" " * (level+1) + "testing #{index}th")
      return [candidate] if terminal?(array, candidate, replacement)
      next if level == 2
      simpler_case = reduction(array, candidate, replacement)
      simpler_solution = toto(simpler_case, level: level + 1)
      return [candidate] + simpler_solution if simpler_solution
    end
    return nil
  end

  def grid_view
    @grid ||= @view.map(&:chr).join.split("\n").map(&:chars)
  end

  def [](x,y)
    grid_view[y][x]
  end

  def []=(xy,value)
    x,y = xy
    grid_view[y][x] = value
  end

  def print_view
    grid_view.each do |line|
      puts line.join
    end
  end

  def neighbour_count(x,y)
    [[x-1, y], [x+1,y], [x,y-1],[x,y+1]].select do |xx,yy|
      self[xx,yy] == '#' rescue false
    end.count
  end

  def intersection?(x,y)
    neighbour_count(x,y) == 4
  end

  def part1
    sum = 0
    grid_view.each_with_index do |line, y|
      line.each_with_index do |el,x|
        if self[x,y] == '#' && intersection?(x,y)
          sum += x * y
        end
      end
    end
    sum 
  end

  def initial_robot_location
    grid_view.each_with_index do |line, y|
      line.each_with_index do |el,x|
        return [x,y] if %w[> < ^ v].include?(self[x,y])
      end
    end
  end

  def path
    to_explore = {}
    grid_view.each_with_index do |line, y|
      line.each_with_index do |el,x|
        to_explore[[x,y]] = true if self[x,y] == '#'
      end
    end
    current_robot_x, current_robot_y = initial_robot_location
    current_direction = self[current_robot_x, current_robot_y]

    total_path = []

    while to_explore.any? { |_,v| v }
      debug2 "Current position: #{current_robot_x},#{current_robot_y}, orientation: #{current_direction}"

      interesting = [[-1, 0], [1,0], [0,-1],[0,1]].select do |delta_x, delta_y|
        self[current_robot_x + delta_x, current_robot_y + delta_y] == '#' && to_explore[[current_robot_x + delta_x, current_robot_y + delta_y]]
      end
      to_explore[[current_robot_x,current_robot_y]] = false unless intersection?(current_robot_x,current_robot_y) && interesting.size == 3
      case interesting.size
      when 0
        if to_explore.any? { |_,v| v }
        coords = [current_robot_x,current_robot_y]
        self[coords] = current_direction
        self.print_view
        require 'pry'
        binding.pry
        raise NotImplementedError
        else
          # finished!
        end
      when 1
        my_path, current_direction = move(current_robot_x, current_robot_y, *interesting.first, current_direction)
        current_robot_x, current_robot_y = [current_robot_x + interesting.first[0], current_robot_y + interesting.first[1]]
        debug2 "Moving #{current_direction} (#{my_path.join})"
        total_path += my_path
        debug2 "Path so far: #{total_path.join}"
      when 2
        coords = [current_robot_x,current_robot_y]
        self[coords] = current_direction
        self.print_view
        require 'pry'
        binding.pry
        raise "Violation of hypothesis: only 4 ways intersections!"
      when 3
        # hypothesis here: we always go straight ahead
        my_path = [1,1]
        print "Moving straight ahead from #{current_robot_x},#{current_robot_y} to " if ENV['DEBUG2']
        case current_direction
        when '>'
          to_explore[[current_robot_x+1,current_robot_y]] = false
          current_robot_x, current_robot_y = [current_robot_x+2, current_robot_y]
        when '^'
          to_explore[[current_robot_x,current_robot_y-1]] = false
          current_robot_x, current_robot_y = [current_robot_x, current_robot_y-2]
        when '<'
          to_explore[[current_robot_x-1,current_robot_y]] = false
          current_robot_x, current_robot_y = [current_robot_x-2, current_robot_y]
        when 'v'
          to_explore[[current_robot_x,current_robot_y+1]] = false
          current_robot_x, current_robot_y = [current_robot_x, current_robot_y+2]
        end
        debug2 "#{current_robot_x},#{current_robot_y} direction: #{current_direction} (#{my_path.join})"
        total_path += my_path
        debug2 "Path so far: #{total_path.join}"
      else
        raise "Looks very weird there are #{interesting.size} possible directions"
      end
    end
    total_path
  end

  def move(x,y, delta_x, delta_y, direction) 
    target_direction = case [delta_x, delta_y]
                       when [-1,0]
                         '<'
                       when [1,0]
                         '>'
                       when [0,-1]
                         '^'
                       when [0,1]
                         'v'
                       end
    instructions = []
    instructions += rotate(direction, target_direction)
    instructions << 1
    [instructions, target_direction]
  end

  # provide "shortest" rotation to target_dir
  # in case of demi-tour: always pick ['L', 'L']
  def rotate(cur_dir, target_dir)
    left_rotations = dir_to_int(target_dir) - dir_to_int(cur_dir)
    left_rotations += 4 if left_rotations < 0
    ['L'] * left_rotations
  end

  def int_to_dir(int)
    case int
    when 1
      '^'
    when 2
      '<'
    when 3
      'v'
    else
      '>'
    end
  end

  def dir_to_int(dir)
    case dir
    when '^'
      1
    when '<'
      2
    when 'v'
      3
    else
      4
    end
  end
end


m = InOut.new
#ENV['DEBUG2'] = ''
iterate(input_copy, stdin: m, stdout: m)
m.print_view if ENV['DEBUG2']

puts "Part 1 #{m.part1}"

# Ideas for part2
# walking on all walls means we will need to walk once on every "segment" between intersections
# if we compute all possible paths (based on those segments), we can have a list of paths formed of '1,L,R,1,1,1,...'
# then we can try to "reduce them" to movement functions where a movement function is a repeated pattern
# difficulties:
# - generate list of all possible paths
# - given a path, find the best "movement functions"
# once we have this we can select any one that fits requirements
# there are 10 intersections so <= 1024 possible path to tests

# small check for helpers function
raise '' unless m.rotate('^', '^').join == ''
raise '' unless m.rotate('^', '<').join == 'L'
raise '' unless m.rotate('^', 'v').join == 'LL'
raise '' unless m.rotate('^', '>').join == 'LLL'
raise '' unless m.rotate('v', '>').join == 'L'

input_copy = input.dup # reset program
input_copy[0] = 2

m = InOut.new
#ENV['DEBUG2'] = ''
iterate(input_copy, stdin: m, stdout: m)

puts "Part2: #{m.part2}"


