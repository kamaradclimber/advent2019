#!/usr/bin/env ruby

input = DATA.read.split(',').map(&:to_i)
input_copy = input.dup

def debug(s)
  puts s if ENV['DEBUG']
end

def debug2(s)
  puts s if ENV['DEBUG2']
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
    raise 'Already consumed stdin' if stdin.empty? && stdin.is_a?(Array)
    raise 'Wrong param mode for output' if modes[0] != 0

    old_value = input[input[index + 1]]
    input[input[index + 1]] = stdin.pop
    puts "Writting stdin #{input[input[index + 1]]} to index #{input[index + 1]} where previous value was #{old_value}" if ENV['DEBUG']
    # puts input.join(",") if ENV['DEBUG']
    2
  when 4
    debug 'stdout'
    stdout << read_param(modes[0], input, index + 1)
    #debug "STDOUT: #{stdout.join(',')}"
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

class Amplifier
  def initialize(stdin:, stdout:, input_program:)
    @stdin = stdin
    @stdout = stdout
    @input_program = input_program.dup
  end

  def run
    iterate(@input_program, stdin: @stdin, stdout: @stdout)
  end
end

def thruster_value(sequence, program)
  stdin = []
  stdout = []
  5.times do |i|
    debug2 "-------------------------------"
    stdout = []
    amp = Amplifier.new(stdin: stdin, stdout: stdout, input_program: program)
    stdin.insert(0, sequence[i])
    stdin << 0 if i == 0
    stdin.reverse!
    debug2 "Running #{i}, stdin: #{stdin.join(',')}"
    amp.run
    debug2 "stdout is #{stdout.join(',')}"
    stdin = stdout
  end
  stdout.join.to_i
end

def max_thruster(program)
  (0..4).to_a.permutation.to_a.map { |sequence| thruster_value(sequence, program) }.max
end

test_program1 = "3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0".split(',').map(&:to_i)
raise "Invalid thruster value example 1" unless 43210 == thruster_value([4,3,2,1,0], test_program1)
raise "Invalid max thruster value example 1" unless 43210 == max_thruster(test_program1)

test_program2 = "3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0".split(',').map(&:to_i)
raise "Invalid thruster value example 2" unless 54321 == thruster_value([0,1,2,3,4], test_program2)
raise "Invalid max thruster value example 2" unless 54321 == max_thruster(test_program2)

test_program3 = "3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0".split(',').map(&:to_i)
raise "Invalid thruster value example 3" unless 65210 == thruster_value([1,0,4,3,2], test_program3)
raise "Invalid max thruster value example 3" unless 65210 == max_thruster(test_program3)

puts "First part: #{max_thruster(input_copy)}"


def thruster_value_part2(sequence, program)
  buffers = (0..4).map { Queue.new }.to_a
  sequence.each_with_index { |phase, index| buffers[index] << phase }
  buffers[0] << 0
  threads = []
  5.times do |i|
    debug2 "-------------------------------"
    amp = Amplifier.new(stdin: buffers[i], stdout: buffers[ (i + 1) % 5], input_program: program)
    threads << Thread.new { amp.run }
  end
  threads.each(&:join)
  thruster = buffers[0]
  thruster.pop
end

def max_thruster_part2(program)
  (5..9).to_a.permutation.to_a.map { |sequence| thruster_value_part2(sequence, program) }.max
end


test_program4 = "3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5".split(',').map(&:to_i)
raise "Invalid thruster value for example 4" unless 139629729 == thruster_value_part2([9,8,7,6,5], test_program4)
raise "Invalid max thruster for example 4" unless 139629729 == max_thruster_part2(test_program4)

test_program5 = "3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10".split(',').map(&:to_i)
raise "Invalid thruster value for example 5" unless 18216 == thruster_value_part2([9,7,8,5,6], test_program5)
raise "Invalid max thruster for example 5" unless 18216 == max_thruster_part2(test_program5)

puts "Part2 : #{max_thruster_part2(input_copy)}"


__END__
3,8,1001,8,10,8,105,1,0,0,21,42,67,76,89,110,191,272,353,434,99999,3,9,102,2,9,9,1001,9,2,9,1002,9,2,9,1001,9,2,9,4,9,99,3,9,1001,9,4,9,102,4,9,9,101,3,9,9,1002,9,2,9,1001,9,4,9,4,9,99,3,9,102,5,9,9,4,9,99,3,9,1001,9,3,9,1002,9,3,9,4,9,99,3,9,102,3,9,9,101,2,9,9,1002,9,3,9,101,5,9,9,4,9,99,3,9,1001,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,99,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,102,2,9,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,99,3,9,102,2,9,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,1,9,9,4,9,3,9,102,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,101,2,9,9,4,9,3,9,1002,9,2,9,4,9,3,9,101,1,9,9,4,9,3,9,1002,9,2,9,4,9,99,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,1002,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,102,2,9,9,4,9,3,9,102,2,9,9,4,9,3,9,1001,9,1,9,4,9,3,9,1001,9,2,9,4,9,3,9,1001,9,1,9,4,9,3,9,101,2,9,9,4,9,99
