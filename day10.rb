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
asteroids_large = asteroids
raise "Failed example5" unless best_location(asteroids) == [[11,13], 210]

asteroids = read_input(DATA.read)

puts "First part: #{best_location(asteroids)[1]}"


def shoot(asteroids)
  ast1, _ = best_location(asteroids)
  values = {}
  by_angle_and_distance = asteroids
    .reject { |ast| ast == ast1 }
    .map { |ast| polar_coords(ast1, ast) }
    .group_by { |angle, r| angle.round(6) }
    .transform_values { |asts| asts.sort_by { |angle, r|  r } }
    .sort_by { |angle, asts| angle }
    .to_h
  orders = []
  starting_index = by_angle_and_distance.keys.find_index { |angle, _| angle > -(Math::PI / 2) }
  index = starting_index
  while by_angle_and_distance.any? { |_, asts| asts.any? }
    angle = by_angle_and_distance.keys[index % by_angle_and_distance.keys.size]
    target = by_angle_and_distance[angle].shift
    if target
      orders << cart_coords(*target, ast1)
    end
    index += 1
  end
  orders
end

def cart_coords(angle, r, ref_ast)
  x, y = ref_ast
  [(r * Math.cos(angle) + x).round(0), (r * Math.sin(angle) + y).round(0)]
end

raise "Failed example" unless shoot(asteroids_large)[199] == [8,2]

puts "Second part: #{shoot(asteroids).map { |x,y| 100 * x + y }[199]}"

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
