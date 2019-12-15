#!/usr/bin/env ruby

require 'pry'

input = DATA.read.split(',').map(&:to_i)
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

class Maze
  def initialize
    @map = {}
    @current_position = [0,0]
    @previous_positions = []
    @map[[0,0]] = {wall: false, distance: 0}
  end

  def <<(el)
    case el
    when 0
      @map[@current_position] = { wall: true}
      @current_position = @previous_positions.pop
    when 1
      unless @map.key?(@current_position)
        new_distance = @map[@previous_positions.reverse.find { |pos| pos != @current_position }][:distance] + 1
        @map[@current_position] = { wall: false, distance: new_distance}
      end
    when 2
      debug2 "Found oxygen at #{@current_position.join(',')}"
      unless @map.key?(@current_position)
        new_distance = @map[@previous_positions.reverse.find { |pos| pos != @current_position }][:distance] + 1
        @map[@current_position] = { wall: false, distance: new_distance, oxygen: true}
      end
    else
      raise "Unknown output #{el}"
    end
  end

  def pop
    debug2 '-------------------'
    print_map if ENV['DEBUG2']
    @previous_positions << @current_position
    x,y = @current_position
    candidates = [[x-1,y],[x+1,y],[x,y-1],[x,y+1]]
    next_pos = candidates.reject { |pos| known?(pos) }.first
    if next_pos.nil? # all explored -> backtracking
      debug2 "Must backtrack"
      next_pos = @current_position
      until next_pos != @current_position
        next_pos = @previous_positions.pop
      end
      if next_pos.nil?
        debug2 "Nowhere to backtrack?"
        raise StopProgram
      end
    end
    debug2 "Moving from #{@current_position.join(',')} to #{next_pos.join(',')}"
    @current_position = next_pos
    case next_pos
    when [x-1, y]
      3 # west
    when [x+1, y]
      4 # east
    when [x, y+1]
      2 # south
    when [x, y-1]
      1 # north
    end
  end


  def wall?(pos)
    @map.key?(pos) && @map[pos][:wall]
  end

  def known?(pos)
    @map.key?(pos)
  end

  def distance_oxygen
    @map.values.find{ |meta| meta[:oxygen] }[:distance]
  end

  def print_map
    min_x = @map.keys.map { |x,y| x }.min
    max_x = @map.keys.map { |x,y| x }.max
    min_y = @map.keys.map { |x,y| y }.min
    max_y = @map.keys.map { |x,y| y }.max
    (min_y..max_y).each do |y|
      (min_x..max_x).each do |x|
        if @map.key?([x,y])
          if [x,y] == @current_position
            print 'D'
          elsif  @map[[x,y]][:wall]
            print '#'
          elsif  @map[[x,y]][:oxygen]
            print 'O'
          else
            print '.' 
          end
        else
          print ' '
        end
      end
      puts ''
    end
  end

  def empty?
    false
  end
end

class StopProgram < RuntimeError; end

m = Maze.new
#ENV['DEBUG2'] = ''
begin
  iterate(input_copy, stdin: m, stdout: m)
rescue StopProgram
end
puts "First part: #{m.distance_oxygen}"


__END__
3,1033,1008,1033,1,1032,1005,1032,31,1008,1033,2,1032,1005,1032,58,1008,1033,3,1032,1005,1032,81,1008,1033,4,1032,1005,1032,104,99,1002,1034,1,1039,101,0,1036,1041,1001,1035,-1,1040,1008,1038,0,1043,102,-1,1043,1032,1,1037,1032,1042,1106,0,124,101,0,1034,1039,101,0,1036,1041,1001,1035,1,1040,1008,1038,0,1043,1,1037,1038,1042,1105,1,124,1001,1034,-1,1039,1008,1036,0,1041,102,1,1035,1040,1001,1038,0,1043,1001,1037,0,1042,1106,0,124,1001,1034,1,1039,1008,1036,0,1041,1002,1035,1,1040,1002,1038,1,1043,101,0,1037,1042,1006,1039,217,1006,1040,217,1008,1039,40,1032,1005,1032,217,1008,1040,40,1032,1005,1032,217,1008,1039,33,1032,1006,1032,165,1008,1040,35,1032,1006,1032,165,1102,2,1,1044,1105,1,224,2,1041,1043,1032,1006,1032,179,1101,1,0,1044,1105,1,224,1,1041,1043,1032,1006,1032,217,1,1042,1043,1032,1001,1032,-1,1032,1002,1032,39,1032,1,1032,1039,1032,101,-1,1032,1032,101,252,1032,211,1007,0,58,1044,1106,0,224,1101,0,0,1044,1106,0,224,1006,1044,247,101,0,1039,1034,101,0,1040,1035,1001,1041,0,1036,1001,1043,0,1038,1001,1042,0,1037,4,1044,1105,1,0,33,14,68,54,69,24,9,59,2,7,68,23,97,53,74,21,32,37,55,83,3,26,85,52,38,10,81,19,82,47,70,27,60,32,98,40,46,75,17,66,11,92,30,84,90,36,71,6,82,95,45,23,75,49,38,71,72,2,72,26,64,93,53,68,90,42,3,64,3,66,21,84,47,15,87,60,18,96,30,14,54,99,48,12,63,62,86,41,56,79,50,99,38,68,16,15,69,53,90,59,28,41,7,94,47,74,68,56,43,70,22,55,72,87,28,50,28,55,98,97,22,64,63,21,28,8,87,91,39,1,93,52,95,96,68,13,24,64,14,65,78,89,34,85,92,35,57,83,70,21,75,43,24,76,74,11,90,55,74,22,63,9,95,64,79,2,78,30,74,75,33,23,47,93,93,56,77,48,72,35,42,82,36,25,20,81,15,56,95,96,33,94,53,46,64,31,46,98,43,40,98,48,6,71,44,83,7,56,64,92,72,24,29,35,37,22,63,21,28,68,75,31,77,28,96,71,35,11,66,55,87,17,64,5,53,95,79,52,95,16,78,80,47,51,90,68,63,1,10,99,79,80,30,97,32,82,27,62,49,1,61,93,71,7,39,93,40,75,50,94,68,22,3,44,5,93,55,53,92,92,16,30,94,17,15,77,55,76,25,97,53,73,96,54,98,39,73,75,5,56,78,81,48,64,73,97,25,71,91,28,56,90,53,75,28,79,63,35,48,81,8,28,95,73,52,30,29,88,4,94,2,36,92,86,87,9,34,92,98,30,99,40,37,87,36,49,34,99,72,38,54,71,1,74,41,20,72,40,90,89,6,1,74,50,63,47,98,79,45,90,78,34,10,78,2,72,94,56,30,86,45,82,74,51,73,88,36,65,30,63,8,17,68,92,13,93,3,77,72,20,90,63,37,86,77,17,95,56,57,61,77,74,19,18,70,34,93,23,96,8,93,1,79,81,66,27,38,2,12,31,81,43,48,93,67,60,17,93,44,99,39,72,35,92,99,42,46,79,60,22,56,75,60,95,23,84,33,67,16,16,36,55,39,83,46,75,80,79,2,63,25,60,20,4,39,97,20,90,4,30,86,9,7,90,80,49,20,98,29,83,51,46,92,27,65,34,57,61,10,94,84,90,3,51,64,5,37,19,51,69,73,39,96,99,24,34,66,21,76,81,33,85,14,67,54,29,94,17,85,8,88,42,6,89,83,9,52,81,90,11,38,95,20,93,81,20,20,86,6,36,69,77,25,15,91,78,32,80,3,22,11,90,89,6,11,73,1,82,46,77,99,26,41,2,75,92,52,13,80,96,44,38,98,47,96,87,28,65,77,17,48,93,93,46,8,82,86,26,84,64,38,53,83,67,97,30,64,39,53,31,63,60,11,86,81,22,84,13,89,75,2,77,5,31,69,3,8,75,60,13,14,90,66,28,66,18,85,70,51,82,94,28,29,99,35,71,75,80,1,93,14,13,91,14,83,24,77,32,8,48,85,96,31,6,54,70,95,32,35,66,80,88,3,96,35,80,54,8,70,30,2,18,59,81,27,31,85,73,35,79,68,30,14,21,67,74,57,60,98,44,46,24,12,60,31,39,68,79,50,3,61,40,75,54,25,85,6,93,56,86,74,98,10,15,66,68,13,44,26,98,40,79,80,14,14,86,30,5,74,66,46,96,17,83,6,98,16,67,91,90,56,97,1,68,14,85,93,69,56,88,40,79,29,91,25,68,69,74,48,66,73,76,17,61,31,62,90,84,46,89,0,0,21,21,1,10,1,0,0,0,0,0,0
