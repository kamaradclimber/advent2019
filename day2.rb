#!/usr/bin/env ruby

input = DATA.read.split(",").map(&:to_i)
input_copy = input.dup

def step(index, input)
  case input[index]
  when 1
    input[input[index+3]] = input[input[index+1]] + input[input[index+2]]
    puts input.join(",") if ENV['DEBUG']
    true
  when 2
    input[input[index+3]] = input[input[index+1]] * input[input[index+2]]
    puts input.join(",") if ENV['DEBUG']
    true
  when 99
    puts "Halt!" if ENV['DEBUG']
    puts input.join(",") if ENV['DEBUG']
    false
  else
    raise "Error #{index}"
  end
end

def iterate(input)
  i = 0
  i+= 4 while step(i, input)
  input
end

example = [1,9,10,3,2,3,11,0,99,30,40,50]
iterate(example)

raise "Bad example1" unless iterate([1,0,0,0,99]) == [2,0,0,0,99]
raise "Bad example2" unless iterate([2,3,0,3,99]) == [2,3,0,6,99]
raise "Bad example3" unless iterate([2,4,4,5,99,0]) == [2,4,4,5,99,9801]
raise "Bad example4" unless iterate([1,1,1,4,99,5,6,0,99]) == [30,1,1,4,2,5,6,0,99]

input_copy[1] = 12
input_copy[2] = 2
iterate(input_copy)
puts "First part: #{input_copy[0]}"


def gravity_assist?(input, objective, noun, verb)
  input_copy = input.dup
  input_copy[1] = noun
  input_copy[2] = verb
  iterate(input_copy)
  input_copy[0] == objective
end

raise "Bad example5" unless gravity_assist?(input, 4930687, 12, 2)

def all_pairs
  sum = 1
  loop do
    verb = 0
    noun = sum
    while noun >= 0 do
      return (noun * 100 + verb) if yield [noun, verb]
      noun -= 1
      verb += 1
    end
    sum += 1
  end
end

example6 = all_pairs do |noun, verb|
  gravity_assist?(input, 4930687, noun, verb)
end
raise "Bad example6" unless example6 == 1202

puts "Part 2: #{all_pairs { |noun, verb| gravity_assist?(input, 19690720, noun, verb) }}"

__END__
1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,13,1,19,1,10,19,23,1,23,9,27,1,5,27,31,2,31,13,35,1,35,5,39,1,39,5,43,2,13,43,47,2,47,10,51,1,51,6,55,2,55,9,59,1,59,5,63,1,63,13,67,2,67,6,71,1,71,5,75,1,75,5,79,1,79,9,83,1,10,83,87,1,87,10,91,1,91,9,95,1,10,95,99,1,10,99,103,2,103,10,107,1,107,9,111,2,6,111,115,1,5,115,119,2,119,13,123,1,6,123,127,2,9,127,131,1,131,5,135,1,135,13,139,1,139,10,143,1,2,143,147,1,147,10,0,99,2,0,14,0
