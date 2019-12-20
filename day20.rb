#!/usr/bin/env ruby

require 'pry'

def debug(s);  puts s if ENV['DEBUG']; end
def debug?; ENV['DEBUG'] end
def debug!; ENV['DEBUG']=''; end
def debug2(s); puts s if ENV['DEBUG2']; end
def debug2?; ENV['DEBUG2'] end
def debug2!; ENV['DEBUG2']= ''; end


def parse_input(input)
  maze = {}
  portals_chars = {}
  input.split("\n").each_with_index do |line,y|
    line.chars.each_with_index do |el,x|
      case el
      when '#', '.'
        maze[[x,y]] = el
      when ' '
        # nothing
      else
        portals_chars[[x,y]] = el
      end
    end
  end
  portals = {}
  portals_chars.keys.each do |point|
    x,y = point
    full_name = nil
    [[x-1,y],[x+1,y],[x,y-1],[x,y+1]].each do |neigh|
      if portals_chars.key?(neigh)
        full_name = if portals_chars[neigh].size == 1 && portals_chars[point].size == 1
          portals_chars[point] + portals_chars[neigh]
        elsif portals_chars[neigh].size == 2
          portals_chars[neigh]
        else
          portals_chars[point]
        end
        portals_chars[point] = full_name
        portals[full_name] ||= []
      end
    end
    [[x-1,y],[x+1,y],[x,y-1],[x,y+1]].each do |neigh|
      if maze[neigh] == '.' # we found location of portal
        maze[neigh] = portals_chars[point]
        portals[full_name] << neigh 
      end
    end
  end
  return [maze,portals]
end

def neighbours(point,maze, portals)
  x,y = point
  neighs = [[x-1,y],[x+1,y],[x,y-1],[x,y+1]].select do |neigh|
    case maze[neigh]
    when '#', ' ', nil
      false
    else
      true
    end
  end
  if maze[point] =~ /^[A-Z]{2}$/
    neighs += portals[maze[point]].reject { |el| el == point } if portals[maze[point]]
  end
  neighs
end


def update_distances(maze, starting_point, portals)
  infinity = 100000000
  distances = Hash.new(infinity)
  debug "Starting point #{starting_point.join(',')}: #{maze[starting_point]}"
  visited = {}
  maze.each {|p,el| visited[p] = false }
  distances[starting_point] = 0
  while visited.any? { |_,v| !v }
    to_explore = visited
      .reject { |point, v| v }
      .min_by { |point, _| distances[point]}
    debug2 "#{to_explore.size} points to explore: #{to_explore.first.join(',')}. #{visited.count { |_,v| v }}/~#{maze.size} points visited"
    x,y = point = to_explore.first
    debug "Visiting #{point.join(',')}"

    neighbours(point, maze, portals).each do |candidate|
      next if visited[candidate]
      current_dist = distances[candidate]
      best_dist = [current_dist, distances[point] + 1].compact.min
      distances[candidate] = best_dist
      debug "Best distance between #{candidate.join(',')} and #{starting_point.join(',')} is (for now) #{distances[candidate]}"
    end
    remaining_to_explore = distances.select { |point, d| visited[point] == false }
    if remaining_to_explore.empty? || remaining_to_explore.values.min >= distances.default 
      debug "End of reachable points"
      return distances
    end

    visited[point] = true
  end
  distances
end



maze1, portals1 = parse_input(<<~INPUT)
         A
         A
  #######.#########
  #######.........#
  #######.#######.#
  #######.#######.#
  #######.#######.#
  #####  B    ###.#
BC...##  C    ###.#
  ##.##       ###.#
  ##...DE  F  ###.#
  #####    G  ###.#
  #########.#####.#
DE..#######...###.#
  #.#########.###.#
FG..#########.....#
  ###########.#####
             Z
             Z
INPUT

distances = update_distances(maze1, portals1['AA'].first, portals1)
raise "Failed example1" unless distances[portals1['ZZ'].first] == 23

maze2, portals2 = parse_input(<<~INPUT)
                   A               
                   A               
  #################.#############  
  #.#...#...................#.#.#  
  #.#.#.###.###.###.#########.#.#  
  #.#.#.......#...#.....#.#.#...#  
  #.#########.###.#####.#.#.###.#  
  #.............#.#.....#.......#  
  ###.###########.###.#####.#.#.#  
  #.....#        A   C    #.#.#.#  
  #######        S   P    #####.#  
  #.#...#                 #......VT
  #.#.#.#                 #.#####  
  #...#.#               YN....#.#  
  #.###.#                 #####.#  
DI....#.#                 #.....#  
  #####.#                 #.###.#  
ZZ......#               QG....#..AS
  ###.###                 #######  
JO..#.#.#                 #.....#  
  #.#.#.#                 ###.#.#  
  #...#..DI             BU....#..LF
  #####.#                 #.#####  
YN......#               VT..#....QG
  #.###.#                 #.###.#  
  #.#...#                 #.....#  
  ###.###    J L     J    #.#.###  
  #.....#    O F     P    #.#...#  
  #.###.#####.#.#####.#####.###.#  
  #...#.#.#...#.....#.....#.#...#  
  #.#####.###.###.#.#.#########.#  
  #...#.#.....#...#.#.#.#.....#.#  
  #.###.#####.###.###.#.#.#######  
  #.#.........#...#.............#  
  #########.###.###.#############  
           B   J   C               
           U   P   P               
INPUT

distances = update_distances(maze2, portals2['AA'].first, portals2)
raise "Failed example2" unless distances[portals2['ZZ'].first] == 58


maze3, portals3 = parse_input(<<~INPUT)
                                   E   X       V       B       J       K   G                                 
                                   Q   B       S       B       F       G   C                                 
  #################################.###.#######.#######.#######.#######.###.###############################  
  #.#...........#...#.....#.....#...#.........#.....#.#.......#.....#.#...........#.#.#.#.......#...#.#.#.#  
  #.###.#######.#.#####.#####.###.#########.#######.#.#.#####.###.#.#.###.#########.#.#.#.###.#.###.#.#.#.#  
  #...#.#.#...............#.......#.#.#.........#.....#...#.....#.#.#...#...#.#...#...#.....#.#.#.........#  
  ###.###.###.###.###.#.#########.#.#.#####.#.#######.#.#####.###.###.#.###.#.#.###.###.#############.#####  
  #.#.#...#...#...#...#.#...........#.....#.#...#.....#.#.#...#.....#.#...#.................#.......#...#.#  
  #.#.###.###.#########.#####.#.#.#####.###.#.#####.#.###.###.#.#####.###.#.#########.#####.###.#####.#.#.#  
  #.#.....#...#.#.#...#.#.#.#.#.#...#.....#.#.#...#.#.......#.#...#...#.......#.#...#.#...#.......#.#.#...#  
  #.#####.#####.#.###.#.#.#.#.###.###.#######.#.###.#########.###.###.#####.###.###.###.#####.###.#.###.###  
  #.#.....#...............#.#.#.........#.#.....#.#...#.......#.....#.....#.................#...#.#.#.....#  
  #.#####.#####.#.###.#.#.#.#########.###.###.###.#.#########.#.#####.#.#.#####.###.#.#########.###.###.#.#  
  #...#.....#...#.#.#.#.#.#.#.#.........#.....#.......#.#.#...#...#...#.#.....#.#...#...#.....#...#...#.#.#  
  #.#####.#########.#####.#.#.###.###.#.#.###.###.###.#.#.###.#.#####.#.###.###.###.#.###.###########.#.###  
  #...#.#.....#.#.#.................#.#.#...#.#...#...#...#.#.#.#...#.#...#...#...#.#.....#.#.#.#.........#  
  #.###.#.#####.#.###.###.#.#.#.###.#####.###.#####.#.#.#.###.#.#.#########.#####.#########.#.#.###.###.###  
  #.#...#.#.#.#.#.....#...#.#.#...#.....#.#.....#...#.#.#.....#.....#.#...#.#...#.#.#.....#.#.....#.#.#.#.#  
  #.#.###.#.#.#.#####.#.#######.###.###.#####.###.###.#.#########.###.###.#.#.#####.#####.#.###.###.#.###.#  
  #...#.........#.#.#.#.#.#.......#...#...#.#.#.#.#...#.......#...#...#...........#...#.....#.#.#.....#.#.#  
  ###.#.#########.#.#####.#####.#.#########.#.#.#####.#####.#.#.#.###.#.#####.#######.###.###.#.###.###.#.#  
  #.......#.#.#...#...#...#.#...#.....#.....#.#.#.#...#.#.#.#.#.#...#.......#.....#.#...#.....#...#...#...#  
  ###.#.###.#.#.###.#####.#.#.#.###.###.#.###.#.#.###.#.#.###.#.#####.###########.#.#.#####.#####.#.###.#.#  
  #...#.........#.#...#.......#.#.#...#.#.....#.....#...#.....#...#...#.....#.#.#.#...#.#.....#...#.#.#.#.#  
  #########.#####.###.#.###.#####.#.###.###.#.#.#.###.#######.#.#####.###.###.#.#####.#.###.#####.#.#.#.###  
  #...........#.#.......#.......#...#.....#.#.#.#.........#...#.....#...............#.#.......#.#.........#  
  #######.#####.###.###.#.#######.#######.#####.#############.#####.#.###.###########.###.#.###.#####.#####  
  #.......#.#.#...#.#.#.#.#      J       I     D             I     K S   N        #...#.#.#.....#.#...#...#  
  #.###.#.#.#.#.#####.#.#.#      F       F     F             K     G F   B        ###.#.#####.###.###.###.#  
  #.#.#.#.#...#.#...#.#.#.#                                                       #...#...................#  
  #.#.###.#.###.#.###.#####                                                       #.#.#.#####.#.#.#.#.###.#  
  #.#.....................#                                                       #.#.#.#...#.#.#.#.#.#...#  
  #######.#######.#.#.#.#.#                                                       #.#.#.#.###.#.#########.#  
  #.....#.#...#.#.#.#.#.#..EQ                                                   NZ..#.#.....#.#.#.......#..DF
  ###.###.#.#.#.###.#.###.#                                                       ###.###.#########.#####.#  
PP........#.#.#.....#.#.#.#                                                       #.#.....#.#.#...#...#.#.#  
  ###########.#########.###                                                       #.#####.#.#.#.#####.#.###  
RJ..#...............#.#.#.#                                                       #.....#.......#.#........NZ
  #.###.#.#.#.#####.#.#.#.#                                                       #.###.#.#.#####.#######.#  
  #.#...#.#.#.#............NC                                                     #.#...#.#.#...#.........#  
  #.#.###########.#.###.#.#                                                       #.#.#######.#.###.#####.#  
  #.#.......#.....#.#...#.#                                                     RJ..#...#.#.#.#...#.....#.#  
  #.#####.#########.###.###                                                       #.###.#.#.###.#######.###  
  #.........#.......#.#...#                                                       #.#.#.................#.#  
  ###############.#.#.###.#                                                       ###.#.###.#############.#  
  #.....#.....#.#.#.#...#.#                                                       #.#.#.#.#.#.#.#.....#.#..JM
  #.###.###.###.#####.#####                                                       #.#.###.###.#.###.#.#.#.#  
ZZ....#.............#.....#                                                     PP......#.....#.....#.....#  
  ###.#.#.###########.#####                                                       ###.#######.#.#########.#  
YR..#.#.#.#.......#.......#                                                       #.#...#.#...#.....#...#.#  
  #.#.#.###.#.###.###.###.#                                                       #.#.###.###.#####.#.#.###  
  #...#.....#.#.......#.#..VS                                                     #.#.................#.#.#  
  ###############.#####.#.#                                                       #.#####.###.###########.#  
  #.....#.....#.#...#.....#                                                     UP....#...#.#.#...........#  
  ###.#.#.###.#.###.#######                                                       #.#.#####.###.###.#.#####  
CX..#.#...#...#...#.#...#..IT                                                     #.#...........#...#...#.#  
  #.#.#####.###.#######.#.#                                                       #.#.#####.#####.#.###.#.#  
  #.#.....#.#...#...#.#...#                                                       #.#...#.#.#...#.#...#.#..DQ
  #.#####.#.#.#.#.###.#.###                                                       ###.###.#####.#.#####.#.#  
  #.......#...#...........#                                                       #.......#.....#.#.#.#...#  
  #########################                                                       #.###.#######.###.#.#####  
  #.........#.#.#.....#....BB                                                     #...#.#.#...#...#........YX
  #.#####.###.#.#.###.###.#                                                       #######.###.#.#.#.###.###  
NB..#...#.........#.#.....#                                                       #...#.....#...#.....#...#  
  ###.#############.#######                                                       #.#####.#####.###########  
  #.................#......AQ                                                     #.....#.#.........#...#.#  
  #.###.#####.#####.#.#####                                                       ###.###.#########.#.###.#  
UP..#...#.#...#...#.....#.#                                                     JM..................#.#...#  
  #.###.#.#######.#######.#                                                       ###.###.#.#########.###.#  
  #.#.#.#.#.#...........#..YG                                                     #.#.#...#...#...........#  
  ###.###.#.#.#######.#.#.#                                                       #.#####.#####.#########.#  
IT..#...........#.....#.#.#                                                     GC..#.#.#...#.......#.#....PE
  #.#.#####.#.#####.###.#.#                                                       #.#.#.#######.#####.###.#  
AA....#.....#...#...#...#.#                                                       #...#.....#.#.#.....#.#.#  
  ###.#.#####.#######.###.#                                                       #.###.#.#.#.#.###.#.#.###  
  #...#.#.....#...........#                                                       #.....#.#.........#.....#  
  ###.#.#.###.###.#.#.###.#        C     Q         X D         Y       Y P        ###.#######.#.#####.###.#  
  #...#.#...#.#...#.#...#.#        X     D         B Q         X       R E        #.......#...#...#.#.#...#  
  ###.#########.#.###.#.#.#########.#####.#########.#.#########.#######.#.###########.#.#.#.#.#.###.#####.#  
  #.....#.#.....#.#...#.#.....#.....#...#.....#.#.#.#...#.......#.......#.........#.#.#.#.#.#.#.......#.#.#  
  #.#.#.#.#####.#####.###########.###.#####.###.#.#.#.###.###.###.###########.#####.#.#########.###.#.#.###  
  #.#.#...#.....#.#.#...#.#.#.......#.........#.....#...#...#.#...#.......#.......#.#.#...#...#...#.#.....#  
  #####.###.#.###.#.#.###.#.#######.#.#####.#.###.#.###.###.#.###.#.###.#.#.#.#.###.#####.###.#.#####.#####  
  #.......#.#.#.#.#.#.#...#.#.#.#...#.....#.#.#...#.#...#...#.#.......#.#.#.#.#...........#.........#.....#  
  #.#.#.#####.#.#.#.#####.#.#.#.#.###.#.#.#########.#.#.#.#.###########.#######.###.###.#.###.#.#.#.###.###  
  #.#.#.....#.#.........#...........#.#.#...#.#...#.#.#.#.#...#...........#...#.#.....#.#...#.#.#.#...#...#  
  #####.#.#######.#.###.###.#.###########.#.#.#.###.#.###.#.#####.#####.###.###.###############.#.#.#######  
  #.....#.#.......#.#.....#.#.......#.#...#.......#.#...#.#...#.#...#.#.#.............#.#.#.....#.#.......#  
  #####.#####.#####.#####.###.###.#.#.#.###.#######.#.###.###.#.#.###.#.#######.###.###.#.###.###.###.#####  
  #.#.....#...#.#.#.#.#.#.#.....#.#...#...#.....#...#.#.....#.#...#...#...#.......#.#.#.#...#...#.#.#.#.#.#  
  #.###.###.#.#.#.###.#.#.###.#########.###.#####.###.###.#######.#.#.#######.#.#####.#.#.###.#####.###.#.#  
  #.......#.#.#...............#...#.#.#.#.#.....#...#...#.#.#.......#.#...#...#...#...#...#.#.....#.#.#.#.#  
  ###.#.###########.#####.###.###.#.#.###.#.###.#.#.###.#.#.###.###.#####.#####.#####.#.###.#######.#.#.#.#  
  #...#...#.#.#...#.#.#.#.#...........#.......#.#.#...#.#...#.#.#...#.......#.........#...#.#.#.#.....#.#.#  
  ###.#####.#.#.#####.#.#.#.#.###.#.#######.#######.###.#.###.###.###.###.#.###.###.###.###.#.#.#.###.#.#.#  
  #.....#.#.#.#.#.#.......#.#.#.#.#.....#.....#.#.....#.#.#.......#...#...#.#...#.#...........#.#.#.....#.#  
  #.#.#.#.#.#.#.#.#.#########.#.###.#######.###.#.#####.#.###.###.#.#.###.#####.#.###.#.#####.#.###.#####.#  
  #.#.#.#.............#.......#.#.#...#.....#...#...#...#.#.#...#...#.#...#.#.......#.#...#...............#  
  ###.#####.#.#.#.###.#.#.#.###.#.#.###.###.#.#.###.###.#.#.#.#####.#######.###.#####.#####.###.#.#.#.#.#.#  
  #.....#.#.#.#.#.#.#.#.#.#.#...#.#...#.#...#.#...#.#.#.#...#.#.........#.#.#.#.#...#.....#.#...#.#.#.#.#.#  
  ###.###.#.#####.#.###.#####.#.###.#######.#.#.###.#.#.#.#####.#.#######.#.#.#.#.###.###.#.###.###.###.#.#  
  #.....#.....#...#.....#.....#.......#.....#.#.....#...#.....#.#.....#.............#.#...#...#...#...#.#.#  
  ###########################.#############.#.#######.#####.#########.#######.#############################  
                             I             N S       I     Q         A       Y                               
                             F             C F       K     D         Q       G                               
INPUT

debug2!
#distances = update_distances(maze3, portals3['AA'].first, portals3)
#puts "First part: #{distances[portals3['ZZ'].first]}"

def update_distances_no_portal(maze, starting_point)
  infinity = 100000000
  distances = Hash.new(infinity)
  debug "Starting point #{starting_point.join(',')}: #{maze[starting_point]}"
  visited = {}
  maze.each {|p,el| visited[p] = false }
  distances[starting_point] = 0
  while visited.any? { |_,v| !v }
    to_explore = visited
      .reject { |point, v| v }
      .min_by { |point, _| distances[point]}
    debug2 "#{to_explore.size} points to explore: #{to_explore.first.join(',')}. #{visited.count { |_,v| v }}/~#{maze.size} points visited"
    point = to_explore.first
    debug "Visiting #{point.join(',')}"

    neighbours(point, maze, {}).each do |candidate|
      next if visited[candidate]
      current_dist = distances[candidate]
      best_dist = [current_dist, distances[point] + 1].compact.min
      distances[candidate] = best_dist
      debug "Best distance between #{candidate.join(',')} and #{starting_point.join(',')} is (for now) #{distances[candidate]}"
    end
    remaining_to_explore = distances.select { |point, d| visited[point] == false }
    if remaining_to_explore.empty? || remaining_to_explore.values.min >= distances.default 
      debug "End of reachable points"
      return distances
    end

    visited[point] = true
  end
  distances
end

def distance_to_maze_center(point, maze)
  middle_x, middle_y = maze.map { |p,_| p[0] }.max / 2, maze.map { |p,_| p[1] }.max / 2
  x, y = point
  (x - middle_x).abs + (y - middle_y).abs
end

# return a distances from an outer portal to its inner version
def outer_to_inner_distances(maze, portals)
  meta_distances = {}
  names = {}
  portals.select { |name, coords| coords.size > 1 }.each do |name, coords|
    outer = coords.max_by { |point| distance_to_maze_center(point, maze) }
    inner = coords.min_by { |point| distance_to_maze_center(point, maze) }
    names["outer_#{name}"] = outer
    names["inner_#{name}"] = inner
  end

  portals.select { |name, coords| coords.size > 1 }.each do |name, coords|
    distance_from_outer = update_distances_no_portal(maze, names["outer_#{name}"])
    meta_distances[["outer_#{name}", "inner_#{name}"]] = 1 # going through portal
    names.each do |dest, point|
      meta_distances[["outer_#{name}", dest]] = distance_from_outer[point] unless "inner_#{name}" == dest || "outer_#{name}" == dest
    end
    distance_from_inner = update_distances_no_portal(maze, names["inner_#{name}"])
    names.each do |dest, point|
      meta_distances[["inner_#{name}", dest]] = distance_from_inner[point] unless "outer_#{name}" == dest || "inner_#{name}" == dest
    end
  end
  distance_from_AA = update_distances_no_portal(maze, portals['AA'].first)
  meta_distances[['AA', 'ZZ']] = distance_from_AA[portals['ZZ'].first]
  portals.each do |dest, coords|
    next unless coords.size == 2
    inner = coords.min_by { |point| distance_to_maze_center(point, maze) }
    #outer = coords.max_by { |point| distance_to_maze_center(point, maze) }
    meta_distances[['AA', "inner_#{dest}"]] = distance_from_AA[inner]
    #meta_distances[['AA', "outer_#{dest}"]] = distance_from_AA[outer]
  end
  meta_distances
end

maze4, portals4 = parse_input(<<~INPUT)
             Z L X W       C
             Z P Q B       K
  ###########.#.#.#.#######.###############
  #...#.......#.#.......#.#.......#.#.#...#
  ###.#.#.#.#.#.#.#.###.#.#.#######.#.#.###
  #.#...#.#.#...#.#.#...#...#...#.#.......#
  #.###.#######.###.###.#.###.###.#.#######
  #...#.......#.#...#...#.............#...#
  #.#########.#######.#.#######.#######.###
  #...#.#    F       R I       Z    #.#.#.#
  #.###.#    D       E C       H    #.#.#.#
  #.#...#                           #...#.#
  #.###.#                           #.###.#
  #.#....OA                       WB..#.#..ZH
  #.###.#                           #.#.#.#
CJ......#                           #.....#
  #######                           #######
  #.#....CK                         #......IC
  #.###.#                           #.###.#
  #.....#                           #...#.#
  ###.###                           #.#.#.#
XF....#.#                         RF..#.#.#
  #####.#                           #######
  #......CJ                       NM..#...#
  ###.#.#                           #.###.#
RE....#.#                           #......RF
  ###.###        X   X       L      #.#.#.#
  #.....#        F   Q       P      #.#.#.#
  ###.###########.###.#######.#########.###
  #.....#...#.....#.......#...#.....#.#...#
  #####.#.###.#######.#######.###.###.#.#.#
  #.......#.......#.#.#.#.#...#...#...#.#.#
  #####.###.#####.#.#.#.#.###.###.#.###.###
  #.......#.....#.#...#...............#...#
  #############.#.#.###.###################
               A O F   N
               A A D   M
INPUT

def update_distances_graph(graph, starting_point)
  infinity = 100000000
  distances = Hash.new(infinity)
  debug "Starting point #{starting_point}"
  visited = {}
  neighbours_graph = {}
  graph.each do |edge, cost|
    a,b = edge
    neighbours_graph[a] ||= []
    neighbours_graph[a] << b
    neighbours_graph[b] ||= []
    neighbours_graph[b] << a
  end
  neighbours_graph.keys.each {|p| visited[p] = false }
  distances[starting_point] = 0
  while visited.any? { |_,v| !v }
    to_explore = visited
      .reject { |point, v| v }
      .min_by { |point, _| distances[point]}
    debug2 "#{to_explore.size} points to explore: #{to_explore.first}. #{visited.count { |_,v| v }}/~#{graph.size} points visited"
    point = to_explore.first
    debug "Visiting #{point}"
    neighbours_graph[point].each do |candidate|
      next if visited[candidate]
      current_dist = distances[candidate]
      d = graph[[point,candidate]] || graph[[candidate,point]]
      best_dist = [current_dist, distances[point] + d].compact.min
      distances[candidate] = best_dist
      debug "Best distance between #{candidate} and #{starting_point} is (for now) #{distances[candidate]}"
    end
    remaining_to_explore = distances.select { |point, d| visited[point] == false }
    if remaining_to_explore.empty? || remaining_to_explore.values.min >= distances.default 
      debug "End of reachable points"
      return distances
    end

    visited[point] = true
  end
  distances
end

meta1 = outer_to_inner_distances(maze1, portals1)
meta2 = outer_to_inner_distances(maze2, portals2)
meta4 = outer_to_inner_distances(maze4, portals4)

a = update_distances_graph(meta1, 'AA')

binding.pry
puts '1'
