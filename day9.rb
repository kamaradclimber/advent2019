#!/usr/bin/env ruby

input = DATA.read.split(',').map(&:to_i)
input_copy = input.dup

def debug(s)
  puts s if ENV['DEBUG']
end

def debug2(s)
  puts s if ENV['DEBUG2']
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
    debug "STDOUT: #{stdout.join(',')}"
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
    false
  else
    raise "Error with unknown opcode #{opcode} at #{index}"
  end
end

class ExtensibleArray < Array
  def initialize(array)
    super()
    array.each_with_index do |el,index|
      self[index] = el
    end
  end

  def [](a)
    case a
    when Integer
      custom_extend(a) if a >= self.size
    when Range
      custom_extend(a.end) if a.end >= self.size
    end
    super
  end

  def []=(a,b)
    custom_extend(a) if a >= self.size
    super
  end

  def custom_extend(index)
    debug "Extend array"
    while index > self.size / 1.5
      self.push(0)
    end
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

stdout = []
stdin = []
copy_program = [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]
iterate(copy_program, stdin: stdin, stdout: stdout)
raise "Invalid copy program example" unless copy_program == stdout

stdout = []
stdin = []
bigint_program = [1102,34915192,34915192,7,4,7,99,0]
iterate(bigint_program, stdin: stdin, stdout: stdout)
raise "Invalid big_int program example" unless stdout.one? && stdout.first.digits.size == 16

stdout = []
stdin = []
middle = [104,1125899906842624,99]
iterate(middle, stdin: stdin, stdout: stdout)
raise "Invalid middle program example" unless stdout.one? && stdout.first == middle[1]

stdout = []
stdin = [1]
iterate(input_copy, stdin: stdin, stdout: stdout)

puts "First part: #{stdout.join(',')}"

stdout = []
stdin = [2]
input_copy = input.dup
iterate(input_copy, stdin: stdin, stdout: stdout)

puts "Second part: #{stdout.join(',')}"

__END__
1102,34463338,34463338,63,1007,63,34463338,63,1005,63,53,1102,1,3,1000,109,988,209,12,9,1000,209,6,209,3,203,0,1008,1000,1,63,1005,63,65,1008,1000,2,63,1005,63,904,1008,1000,0,63,1005,63,58,4,25,104,0,99,4,0,104,0,99,4,17,104,0,99,0,0,1101,39,0,1004,1101,0,37,1013,1101,0,28,1001,1101,0,38,1005,1101,23,0,1008,1102,1,0,1020,1102,1,26,1010,1102,31,1,1009,1101,29,0,1015,1102,459,1,1024,1101,33,0,1007,1101,0,30,1016,1101,32,0,1002,1102,1,494,1027,1101,0,216,1029,1101,497,0,1026,1101,0,303,1022,1102,1,21,1018,1102,1,36,1006,1102,1,27,1014,1102,296,1,1023,1102,454,1,1025,1102,35,1,1003,1101,22,0,1017,1102,225,1,1028,1102,1,20,1011,1101,1,0,1021,1101,0,24,1000,1101,0,25,1019,1101,0,34,1012,109,13,21102,40,1,0,1008,1013,40,63,1005,63,203,4,187,1106,0,207,1001,64,1,64,1002,64,2,64,109,5,2106,0,10,4,213,1001,64,1,64,1105,1,225,1002,64,2,64,109,-3,1206,6,241,1001,64,1,64,1105,1,243,4,231,1002,64,2,64,109,-17,2108,30,4,63,1005,63,259,1106,0,265,4,249,1001,64,1,64,1002,64,2,64,109,14,2108,35,-9,63,1005,63,283,4,271,1105,1,287,1001,64,1,64,1002,64,2,64,109,13,2105,1,-2,1001,64,1,64,1106,0,305,4,293,1002,64,2,64,109,-28,1208,5,32,63,1005,63,327,4,311,1001,64,1,64,1106,0,327,1002,64,2,64,109,12,2102,1,0,63,1008,63,31,63,1005,63,353,4,333,1001,64,1,64,1105,1,353,1002,64,2,64,109,7,21102,41,1,-6,1008,1010,40,63,1005,63,373,1105,1,379,4,359,1001,64,1,64,1002,64,2,64,109,-4,2102,1,-6,63,1008,63,35,63,1005,63,403,1001,64,1,64,1105,1,405,4,385,1002,64,2,64,109,11,21107,42,43,-4,1005,1019,427,4,411,1001,64,1,64,1105,1,427,1002,64,2,64,109,-10,1206,7,445,4,433,1001,64,1,64,1105,1,445,1002,64,2,64,109,10,2105,1,1,4,451,1105,1,463,1001,64,1,64,1002,64,2,64,109,-14,21108,43,42,4,1005,1013,479,1106,0,485,4,469,1001,64,1,64,1002,64,2,64,109,12,2106,0,6,1106,0,503,4,491,1001,64,1,64,1002,64,2,64,109,-10,2107,30,-2,63,1005,63,521,4,509,1106,0,525,1001,64,1,64,1002,64,2,64,109,-7,2101,0,-4,63,1008,63,26,63,1005,63,549,1001,64,1,64,1106,0,551,4,531,1002,64,2,64,109,13,21107,44,43,-3,1005,1014,571,1001,64,1,64,1105,1,573,4,557,1002,64,2,64,109,-6,21108,45,45,1,1005,1012,591,4,579,1106,0,595,1001,64,1,64,1002,64,2,64,109,8,1205,2,609,4,601,1106,0,613,1001,64,1,64,1002,64,2,64,109,-11,1208,-6,34,63,1005,63,629,1106,0,635,4,619,1001,64,1,64,1002,64,2,64,109,-15,2107,33,9,63,1005,63,651,1106,0,657,4,641,1001,64,1,64,1002,64,2,64,109,9,1207,2,38,63,1005,63,677,1001,64,1,64,1106,0,679,4,663,1002,64,2,64,109,8,21101,46,0,0,1008,1010,45,63,1005,63,703,1001,64,1,64,1106,0,705,4,685,1002,64,2,64,109,-5,1201,-3,0,63,1008,63,32,63,1005,63,727,4,711,1106,0,731,1001,64,1,64,1002,64,2,64,109,-6,1207,8,34,63,1005,63,753,4,737,1001,64,1,64,1106,0,753,1002,64,2,64,109,29,1205,-8,765,1106,0,771,4,759,1001,64,1,64,1002,64,2,64,109,-18,1202,-6,1,63,1008,63,39,63,1005,63,797,4,777,1001,64,1,64,1106,0,797,1002,64,2,64,109,8,21101,47,0,0,1008,1018,47,63,1005,63,823,4,803,1001,64,1,64,1105,1,823,1002,64,2,64,109,-12,2101,0,-3,63,1008,63,35,63,1005,63,845,4,829,1106,0,849,1001,64,1,64,1002,64,2,64,109,-9,1201,5,0,63,1008,63,30,63,1005,63,869,1105,1,875,4,855,1001,64,1,64,1002,64,2,64,109,8,1202,-2,1,63,1008,63,34,63,1005,63,899,1001,64,1,64,1105,1,901,4,881,4,64,99,21101,27,0,1,21101,0,915,0,1105,1,922,21201,1,45467,1,204,1,99,109,3,1207,-2,3,63,1005,63,964,21201,-2,-1,1,21101,942,0,0,1106,0,922,21201,1,0,-1,21201,-2,-3,1,21102,1,957,0,1105,1,922,22201,1,-1,-2,1105,1,968,22101,0,-2,-2,109,-3,2106,0,0
