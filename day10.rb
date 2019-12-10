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

def polar_coords(ref_ast, ast)
  x1, y1 = ref_ast
  x2, y2 = ast
  r = Math.sqrt( (x2 - x1) ** 2 + (y2 - y1) ** 2)
  angle = Math.atan2( (y2 - y1).to_f, (x2 - x1).to_f)
  [angle, r]
end

def best_location(asteroids)
  values = {}
  best = asteroids.max_by do |ast1|
    asteroids
      .reject { |ast| ast == ast1 }
      .map { |ast| polar_coords(ast1, ast) }
      .group_by { |angle, r| angle.round(6) }
      .size
      .tap { |visible| values[ast1] = visible }
  end
  [best, values[best]]
end

#def best_location(asteroids)
#  debug "#{asteroids.size} asteroids there"
#  values = {}
#  best = asteroids.max_by do |ast1|
#    c = asteroids.reject { |ast2| ast1 == ast2 }.count do |ast2|
#      v = visible?(ast1, ast2, asteroids)
#      debug2 "#{ast1.join(',')} -> #{ast2.join(',')} : #{v}"
#      v
#    end
#    debug "#{ast1.join(', ')}: #{c}"
#    values[ast1] = c
#    c
#  end
#  [best, values[best]]
#end

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
puts best_location(asteroids).join(':')
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
