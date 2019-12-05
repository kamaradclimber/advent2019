#!/usr/bin/env ruby

input = DATA.read.split(',').map(&:to_i)
input_copy = input.dup

def debug(s)
  puts s if ENV['DEBUG']
end

def read_param(param_mode, input, index)
  case param_mode
  when 0 # position mode
    debug "Reading param at index #{index} in position mode, points to index #{input[index]}, value #{input[input[index]]}"
    input[input[index]]
  when 1
    debug "Reading param at index #{index} in immediate mode, value #{input[index]}"
    input[index]
  else
    raise "Unknown param_mode #{param_mode}"
  end
end

def read_next(input, index, intake)
  puts input[index..(index + intake - 1)].join(' ') if ENV['DEBUG']
end

def step(index, input, stdin: [], stdout: [])
  opcode = input[index] % 100
  modes = (input[index] / 100).digits + [0] * 3 # extend modes with enough 0s
  read_next(input, index, 8)
  print "Opcode is #{opcode} " if ENV['DEBUG']
  case opcode
  when 1
    debug 'addition'
    raise 'Wrong param mode for output' if modes[2] != 0

    old_value = input[input[index + 3]]
    input[input[index + 3]] = read_param(modes[0], input, index + 1) + read_param(modes[1], input, index + 2)
    puts "Putting #{input[input[index + 3]]} at index #{input[index + 3]} where previous value was #{old_value}" if ENV['DEBUG']
    # puts input.join(",") if ENV['DEBUG']
    4
  when 2
    debug 'multiplication'
    raise 'Wrong param mode for output' if modes[2] != 0

    input[input[index + 3]] = read_param(modes[0], input, index + 1) * read_param(modes[1], input, index + 2)
    # puts input.join(",") if ENV['DEBUG']
    4
  when 3
    debug 'stdin'
    raise 'Already consumed stdin' if stdin.empty?
    raise 'Wrong param mode for output' if modes[0] != 0

    old_value = input[input[index + 1]]
    input[input[index + 1]] = stdin.pop
    puts "Writting stdin #{input[input[index + 1]]} to index #{input[index + 1]} where previous value was #{old_value}" if ENV['DEBUG']
    # puts input.join(",") if ENV['DEBUG']
    2
  when 4
    debug 'stdout'
    stdout << read_param(modes[0], input, index + 1)
    puts "STDOUT: #{stdout.join(',')}" if ENV['DEBUG']
    2
  when 5
    debug 'jump-if-true'
    if read_param(modes[0], input, index + 1) != 0
      puts "Jumping to #{read_param(modes[1], input, index + 2)}" if ENV['DEBUG']
      # puts input.join(",") if ENV['DEBUG']
      read_param(modes[1], input, index + 2) - index
    else
      puts 'Not jumping' if ENV['DEBUG']
      3
    end
  when 6
    debug 'jump-if-false'
    if read_param(modes[0], input, index + 1) == 0
      puts "Jumping to #{read_param(modes[1], input, index + 2)}" if ENV['DEBUG']
      # puts input.join(",") if ENV['DEBUG']
      read_param(modes[1], input, index + 2) - index
    else
      puts 'Not jumping' if ENV['DEBUG']
      3
    end
  when 7
    debug 'lower-than'
    raise 'Wrong param mode for output' if modes[2] != 0

    a = read_param(modes[0], input, index + 1)
    b = read_param(modes[1], input, index + 2)
    input[input[index + 3]] = a < b ? 1 : 0
    # puts input.join(",") if ENV['DEBUG']
    4
  when 8
    debug 'equal'
    raise 'Wrong param mode for output' if modes[2] != 0

    a = read_param(modes[0], input, index + 1)
    b = read_param(modes[1], input, index + 2)
    input[input[index + 3]] = a == b ? 1 : 0
    # puts input.join(",") if ENV['DEBUG']
    4
  when 99
    debug 'Halt!' if ENV['DEBUG']
    # puts input.join(",") if ENV['DEBUG']
    false
  else
    raise "Error with unknown opcode #{opcode} at #{index}"
  end
end

def iterate(input, stdin: [], stdout: [])
  # puts input.join(",") if ENV['DEBUG']
  i = 0
  increment = 0
  while (increment = step(i, input, stdin: stdin, stdout: stdout))
    puts "Moving cursor from #{i} to #{i + increment}" if ENV['DEBUG']
    i += increment
  end
  input
end

example = [1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50]
iterate(example)

raise 'Bad example1' unless iterate([1, 0, 0, 0, 99]) == [2, 0, 0, 0, 99]
raise 'Bad example2' unless iterate([2, 3, 0, 3, 99]) == [2, 3, 0, 6, 99]
raise 'Bad example3' unless iterate([2, 4, 4, 5, 99, 0]) == [2, 4, 4, 5, 99, 9801]
raise 'Bad example4' unless iterate([1, 1, 1, 4, 99, 5, 6, 0, 99]) == [30, 1, 1, 4, 2, 5, 6, 0, 99]

stdout = []
raise 'Bad example5' unless iterate([3, 0, 4, 0, 99], stdin: [42], stdout: stdout) == [42, 0, 4, 0, 99]
raise 'Bad stdout' unless stdout == [42]

raise 'Bad example6' unless iterate([1002, 4, 3, 4, 33]) == [1002, 4, 3, 4, 99]

raise 'Bad example7' unless iterate([1101, 100, -1, 4, 0]) == [1101, 100, -1, 4, 99]

stdout = []
iterate(input_copy, stdin: [1], stdout: stdout)
raise 'Bad diagnostic first part' if stdout[0..-1].all?(&:zero?)

puts "First part: #{stdout.last}"
raise 'Regression on part 1 ' unless stdout.last == 9_431_221

stdout = []
iterate([3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8], stdout: stdout, stdin: [8])
raise 'Bad example8' unless stdout == [1]

stdout = []
iterate([3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8], stdout: stdout, stdin: [7])
raise 'Bad example8bis' unless stdout == [0]

stdout = []
iterate([3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8], stdout: stdout, stdin: [7])
raise 'Bad example9' unless stdout == [1]

stdout = []
iterate([3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8], stdout: stdout, stdin: [8])
raise 'Bad example9bis' unless stdout == [0]

stdout = []
iterate([3, 9, 7, 9, 10, 9, 4, 9, 99, -1, 8], stdout: stdout, stdin: [9])
raise 'Bad example9bis' unless stdout == [0]

stdout = []
iterate([3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9], stdout: stdout, stdin: [0])
raise 'Bad jump example' unless stdout == [0]

stdout = []
iterate([3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9], stdout: stdout, stdin: [1])
raise 'Bad jump example bis' unless stdout == [1]

stdout = []
iterate([3, 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99, 1], stdout: stdout, stdin: [0])
raise 'Bad jump example ter' unless stdout == [0]

stdout = []
iterate([3, 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99, 1], stdout: stdout, stdin: [1])
raise 'Bad jump example quatro' unless stdout == [1]

stdout = []
iterate([3, 21, 1008, 21, 8, 20, 1005, 20, 22, 107, 8, 21, 20, 1006, 20, 31, 1106, 0, 36, 98, 0, 0, 1002, 21, 125, 20, 4, 20, 1105, 1, 46, 104, 999, 1105, 1, 46, 1101, 1000, 1, 20, 4, 20, 1105, 1, 46, 98, 99], stdout: stdout, stdin: [7])
raise 'Bad full example' unless stdout == [999]

stdout = []
iterate([3, 21, 1008, 21, 8, 20, 1005, 20, 22, 107, 8, 21, 20, 1006, 20, 31, 1106, 0, 36, 98, 0, 0, 1002, 21, 125, 20, 4, 20, 1105, 1, 46, 104, 999, 1105, 1, 46, 1101, 1000, 1, 20, 4, 20, 1105, 1, 46, 98, 99], stdout: stdout, stdin: [8])
raise 'Bad full example bis' unless stdout == [1000]

stdout = []
iterate([3, 21, 1008, 21, 8, 20, 1005, 20, 22, 107, 8, 21, 20, 1006, 20, 31, 1106, 0, 36, 98, 0, 0, 1002, 21, 125, 20, 4, 20, 1105, 1, 46, 104, 999, 1105, 1, 46, 1101, 1000, 1, 20, 4, 20, 1105, 1, 46, 98, 99], stdout: stdout, stdin: [9])
raise 'Bad full example ter' unless stdout == [1001]

stdout = []
iterate([3, 3, 1108, -1, 8, 3, 4, 3, 99], stdout: stdout, stdin: [8])
raise 'Bad comparison example' unless stdout == [1]

stdout = []
iterate([3, 3, 1108, -1, 8, 3, 4, 3, 99], stdout: stdout, stdin: [9])
raise 'Bad comparison example bis' unless stdout == [0]

stdout = []
iterate([3, 3, 1107, -1, 8, 3, 4, 3, 99], stdout: stdout, stdin: [7])
raise 'Bad < example' unless stdout == [1]

stdout = []
iterate([3, 3, 1107, -1, 8, 3, 4, 3, 99], stdout: stdout, stdin: [8])
raise 'Bad < example bis' unless stdout == [0]

puts '----------------------'
ENV['DEBUG'] = ''

input_copy = input.dup
stdout = []
iterate(input_copy, stdin: [5], stdout: stdout)
puts "Second part: #{stdout.last}"

__END__
3,225,1,225,6,6,1100,1,238,225,104,0,1001,152,55,224,1001,224,-68,224,4,224,1002,223,8,223,1001,224,4,224,1,224,223,223,1101,62,41,225,1101,83,71,225,102,59,147,224,101,-944,224,224,4,224,1002,223,8,223,101,3,224,224,1,224,223,223,2,40,139,224,1001,224,-3905,224,4,224,1002,223,8,223,101,7,224,224,1,223,224,223,1101,6,94,224,101,-100,224,224,4,224,1002,223,8,223,101,6,224,224,1,224,223,223,1102,75,30,225,1102,70,44,224,101,-3080,224,224,4,224,1002,223,8,223,1001,224,4,224,1,223,224,223,1101,55,20,225,1102,55,16,225,1102,13,94,225,1102,16,55,225,1102,13,13,225,1,109,143,224,101,-88,224,224,4,224,1002,223,8,223,1001,224,2,224,1,223,224,223,1002,136,57,224,101,-1140,224,224,4,224,1002,223,8,223,101,6,224,224,1,223,224,223,101,76,35,224,1001,224,-138,224,4,224,1002,223,8,223,101,5,224,224,1,223,224,223,4,223,99,0,0,0,677,0,0,0,0,0,0,0,0,0,0,0,1105,0,99999,1105,227,247,1105,1,99999,1005,227,99999,1005,0,256,1105,1,99999,1106,227,99999,1106,0,265,1105,1,99999,1006,0,99999,1006,227,274,1105,1,99999,1105,1,280,1105,1,99999,1,225,225,225,1101,294,0,0,105,1,0,1105,1,99999,1106,0,300,1105,1,99999,1,225,225,225,1101,314,0,0,106,0,0,1105,1,99999,1008,677,677,224,1002,223,2,223,1006,224,329,1001,223,1,223,8,677,226,224,102,2,223,223,1006,224,344,101,1,223,223,1107,226,226,224,1002,223,2,223,1006,224,359,1001,223,1,223,1108,677,226,224,102,2,223,223,1005,224,374,1001,223,1,223,1007,226,226,224,102,2,223,223,1006,224,389,1001,223,1,223,108,677,677,224,1002,223,2,223,1005,224,404,1001,223,1,223,1007,677,677,224,102,2,223,223,1005,224,419,1001,223,1,223,8,226,677,224,102,2,223,223,1005,224,434,101,1,223,223,1008,677,226,224,102,2,223,223,1006,224,449,1001,223,1,223,7,677,677,224,102,2,223,223,1006,224,464,1001,223,1,223,8,226,226,224,1002,223,2,223,1005,224,479,1001,223,1,223,7,226,677,224,102,2,223,223,1006,224,494,1001,223,1,223,7,677,226,224,1002,223,2,223,1005,224,509,101,1,223,223,107,677,677,224,102,2,223,223,1006,224,524,101,1,223,223,1007,677,226,224,102,2,223,223,1006,224,539,101,1,223,223,107,226,226,224,1002,223,2,223,1006,224,554,101,1,223,223,1008,226,226,224,102,2,223,223,1006,224,569,1001,223,1,223,1107,677,226,224,1002,223,2,223,1005,224,584,101,1,223,223,1107,226,677,224,102,2,223,223,1005,224,599,101,1,223,223,1108,226,677,224,102,2,223,223,1005,224,614,101,1,223,223,108,677,226,224,102,2,223,223,1005,224,629,101,1,223,223,107,226,677,224,102,2,223,223,1006,224,644,1001,223,1,223,1108,226,226,224,1002,223,2,223,1006,224,659,101,1,223,223,108,226,226,224,102,2,223,223,1005,224,674,101,1,223,223,4,223,99,226
