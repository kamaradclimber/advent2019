#!/usr/bin/env ruby

def debug(s)
  puts s if ENV['DEBUG']
end

def debug2(s)
  puts s if ENV['DEBUG2']
end

def read_input(input)
  asteroids = []
  input.split("\n").map(&:chars).each_with_index do |line, y|
    line.each_with_index do |el, x|
      case el
      when '#'
        asteroids << [x,y]
      when '.'
        # do nothing
      else
        raise "Unknown element #{el}"
      end
    end
  end
  asteroids
end

# return (a,b) where line is ax + b
def line(ast1, ast2)
  x1, y1 = ast1
  x2, y2 = ast2
  if x1 == x2
    [x1, :vertical] # special case in case of vertical line
  elsif y1 == y2
    [0, y1]
  else
    a = (y2 - y1).to_f / (x2 - x1).to_f
    b = y2 - a * x2
    [a, b]
  end
end

class Symbol
  def round(n)
    self
  end
end

def aligned?(ast1, ast2, ast3)
  a1, b1 = line(ast1, ast2)
  a2, b2 = line(ast1, ast3)
  precision = 6
  b1.round(precision) == b2.round(precision) && a1.round(precision) == a2.round(precision)
end

def distance(ast1, ast2)
  x1, y1 = ast1
  x2, y2 = ast2
  (y2 - y1) ** 2 + (x2 - x1) ** 2 
end

def visible?(ast1, ast2, asteroids)
  asteroids.reject { |ast| ast == ast1 || ast == ast2 }.none? do |ast3|
    aligned?(ast1, ast2, ast3) &&
      distance(ast1, ast3) < distance(ast1, ast2) &&
      distance(ast2, ast3) < distance(ast1, ast2)
  end
end

raise "Horizontal alignement" unless aligned?( [0,0], [1,0], [2,0])
raise "Diagonal alignement" unless aligned?([0,0], [1,1], [2,2])

def best_location(asteroids)
  debug "#{asteroids.size} asteroids there"
  values = {}
  best = asteroids.max_by do |ast1|
    c = asteroids.reject { |ast2| ast1 == ast2 }.count do |ast2|
      v = visible?(ast1, ast2, asteroids)
      debug2 "#{ast1.join(',')} -> #{ast2.join(',')} : #{v}"
      v
    end
    debug "#{ast1.join(', ')}: #{c}"
    values[ast1] = c
    c
  end
  [best, values[best]]
end

asteroids = read_input(<<~MAP)
.#..#
.....
#####
....#
...##
MAP
raise "Failed example1" unless best_location(asteroids) == [[3,4], 8]


asteroids = read_input(<<~MAP)
......#.#.
#..#.#....
..#######.
.#.#.###..
.#..#.....
..#....#.#
#..#....#.
.##.#..###
##...#..#.
.#....####
MAP
raise "Failed example2" unless best_location(asteroids) == [[5,8], 33]

asteroids = read_input(<<~MAP)
#.#...#.#.
.###....#.
.#....#...
##.#.#.#.#
....#.#.#.
.##..###.#
..#...##..
..##....##
......#...
.####.###.
MAP
raise "Failed example3" unless best_location(asteroids) == [[1,2], 35]

asteroids = read_input(<<~MAP)
.#..#..###
####.###.#
....###.#.
..###.##.#
##.##.#.#.
....###..#
..#.#..#.#
#..#.#.###
.##...##.#
.....#.#..
MAP
raise "Failed example4" unless best_location(asteroids) == [[6,3], 41]

asteroids = read_input(<<~MAP)
.#..##.###...#######
##.############..##.
.#.######.########.#
.###.#######.####.#.
#####.##.#.##.###.##
..#####..#.#########
####################
#.####....###.#.#.##
##.#################
#####.##.###..####..
..######..##.#######
####.##.####...##..#
.#####..#.######.###
##...#.##########...
#.##########.#######
.####.#.###.###.#.##
....##.##.###..#####
.#.#.###########.###
#.#.#.#####.####.###
###.##.####.##.#..##
MAP
raise "Failed example5" unless best_location(asteroids) == [[11,13], 210]

asteroids = read_input(DATA.read)

puts "First part: #{best_location(asteroids)[1]}"



__END__
.#..#..#..#...#..#...###....##.#....
.#.........#.#....#...........####.#
#..##.##.#....#...#.#....#..........
......###..#.#...............#.....#
......#......#....#..##....##.......
....................#..............#
..#....##...#.....#..#..........#..#
..#.#.....#..#..#..#.#....#.###.##.#
.........##.#..#.......#.........#..
.##..#..##....#.#...#.#.####.....#..
.##....#.#....#.......#......##....#
..#...#.#...##......#####..#......#.
##..#...#.....#...###..#..........#.
......##..#.##..#.....#.......##..#.
#..##..#..#.....#.#.####........#.#.
#......#..........###...#..#....##..
.......#...#....#.##.#..##......#...
.............##.......#.#.#..#...##.
..#..##...#...............#..#......
##....#...#.#....#..#.....##..##....
.#...##...........#..#..............
.............#....###...#.##....#.#.
#..#.#..#...#....#.....#............
....#.###....##....##...............
....#..........#..#..#.......#.#....
#..#....##.....#............#..#....
...##.............#...#.....#..###..
...#.......#........###.##..#..##.##
.#.##.#...##..#.#........#.....#....
#......#....#......#....###.#.....#.
......#.##......#...#.#.##.##...#...
..#...#.#........#....#...........#.
......#.##..#..#.....#......##..#...
..##.........#......#..##.#.#.......
.#....#..#....###..#....##..........
..............#....##...#.####...##.
