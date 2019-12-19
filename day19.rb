#!/usr/bin/env ruby

require 'pry'

DATA = "109,424,203,1,21101,11,0,0,1106,0,282,21102,18,1,0,1106,0,259,1201,1,0,221,203,1,21102,31,1,0,1106,0,282,21101,0,38,0,1105,1,259,21002,23,1,2,21202,1,1,3,21102,1,1,1,21102,1,57,0,1105,1,303,2101,0,1,222,21002,221,1,3,21002,221,1,2,21101,0,259,1,21101,0,80,0,1105,1,225,21101,169,0,2,21101,0,91,0,1106,0,303,1202,1,1,223,20101,0,222,4,21101,259,0,3,21102,225,1,2,21102,225,1,1,21101,0,118,0,1106,0,225,20102,1,222,3,21101,94,0,2,21101,0,133,0,1106,0,303,21202,1,-1,1,22001,223,1,1,21102,148,1,0,1105,1,259,2102,1,1,223,21001,221,0,4,21002,222,1,3,21101,0,22,2,1001,132,-2,224,1002,224,2,224,1001,224,3,224,1002,132,-1,132,1,224,132,224,21001,224,1,1,21101,0,195,0,106,0,108,20207,1,223,2,21002,23,1,1,21102,1,-1,3,21102,214,1,0,1105,1,303,22101,1,1,1,204,1,99,0,0,0,0,109,5,1202,-4,1,249,21201,-3,0,1,21202,-2,1,2,22101,0,-1,3,21101,0,250,0,1106,0,225,21202,1,1,-4,109,-5,2106,0,0,109,3,22107,0,-2,-1,21202,-1,2,-1,21201,-1,-1,-1,22202,-1,-2,-2,109,-3,2105,1,0,109,3,21207,-2,0,-1,1206,-1,294,104,0,99,21202,-2,1,-2,109,-3,2105,1,0,109,5,22207,-3,-4,-1,1206,-1,346,22201,-4,-3,-4,21202,-3,-1,-1,22201,-4,-1,2,21202,2,-1,-1,22201,-4,-1,1,22101,0,-2,3,21102,343,1,0,1105,1,303,1106,0,415,22207,-2,-3,-1,1206,-1,387,22201,-3,-2,-3,21202,-2,-1,-1,22201,-3,-1,3,21202,3,-1,-1,22201,-3,-1,2,21201,-4,0,1,21101,0,384,0,1105,1,303,1106,0,415,21202,-4,-1,-4,22201,-4,-3,-4,22202,-3,-2,-2,22202,-2,-4,-4,22202,-3,-2,-3,21202,-4,-1,-2,22201,-3,-2,1,21201,1,0,-4,109,-5,2106,0,0"
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
  attr_reader :out
  def initialize(x,y)
    @input = [x,y]
  end

  def <<(el)
    @out = el
  end


  def pop
    @input.pop # this is buggy, it should be shift
  end

  def empty?
    @input.empty?
  end
end

shape = {}
simple_shape = []
(0..6).each do |y|
  (0..100).each do |x|
    input_copy = input.dup # reset program
    m = InOut.new(x,y)
    #ENV['DEBUG2'] = ''
    iterate(input_copy, stdin: m, stdout: m)
    shape[[x,y]] = true if m.out == 1
  end
  min_x = shape.keys.select { |a,b| b == y }.map(&:first).min
  max_x = shape.keys.select { |a,b| b == y }.map(&:first).max
  simple_shape << (min_x..max_x)
  puts "#{y} #{(min_x..max_x)}"
end
puts "First part #{shape.count { |_,v| v }}"
puts "First part #{simple_shape.map { |r| r.size }.compact.sum}"

def discover_shape(input, simple_shape)
  square_size = 100

  while true
    y = simple_shape.size - 1
    range = simple_shape.last
    puts "Trying #{y+1}, last shape (line above) is #{range}"
    min_x = range.begin
    max_x = range.end

    candidates = [[min_x, y+1],[min_x+1,y+1] ,[min_x+2,y+1], [min_x+3,y+1]]
    min_xx, _= candidates.find do |a,b|
      input_copy = input.dup # reset program
      m = InOut.new(a,b)
      iterate(input_copy, stdin: m, stdout: m)
      m.out == 1
    end
    candidates = [[max_x, y+1],[max_x+1,y+1],[max_x+2,y+1],[max_x+3,y+1]].reverse
    max_xx, _= candidates.find do |a,b|
      input_copy = input.dup # reset program
      m = InOut.new(a,b)
      iterate(input_copy, stdin: m, stdout: m)
      m.out == 1
    end
    simple_shape << (min_xx..max_xx)

    #puts "#{y+1}: #{simple_shape.last}"

    upper_y = y+1-(square_size-1)
    if upper_y >= 0
      if (simple_shape[upper_y].size||0) >= square_size
        common_xes = simple_shape[upper_y].to_a & simple_shape[y+1].to_a
        #puts "y:#{upper_y} -> y:#{y+1}: size of #{square_size} lines above is #{simple_shape[upper_y].size}. Ranges are #{simple_shape[y+1]} and #{simple_shape[upper_y]}. Intersection size is #{common_xes.size}"
        if common_xes.size  >= square_size
          return common_xes.first + upper_y * 10000
        end
      end
    end
  end
end
puts discover_shape(input,simple_shape)

#(0..30).each do |y|
#  (0..50).each do |x|
#    print((simple_shape[y] && simple_shape[y].size && simple_shape[y].include?(x)) ? "#" : ".")
#  end
#  puts
#end


