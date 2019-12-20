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
    neighs += portals[maze[point]].reject { |el| el == point }
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



maze, portals = parse_input(<<~INPUT)
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

distances = update_distances(maze, portals['AA'].first, portals)
raise "Failed example1" unless distances[portals['ZZ'].first] == 23

maze, portals = parse_input(<<~INPUT)
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

distances = update_distances(maze, portals['AA'].first, portals)
raise "Failed example2" unless distances[portals['ZZ'].first] == 58


maze, portals = parse_input(<<~INPUT)
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
distances = update_distances(maze, portals['AA'].first, portals)
puts "First part: #{distances[portals['ZZ'].first]}"
