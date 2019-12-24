#!/usr/bin/env ruby
#

require 'pry'
require 'set'

class Eris
  def initialize(input)
    @map = input.split("\n").map do |line|
      line.chars
    end
  end

  def [](coords)
    x,y = coords
    @map[y][x]
  end

  def neighbours(coords)
    x,y = coords
    [[x-1,y],[x+1,y],[x,y-1],[x,y+1]].select do |a,b|
      b>=0 && b < @map.size && a >= 0 && a < @map[b].size
    end
  end

  def adjacent_bug_count(coords)
    neighbours(coords).select { |a,b| self[[a,b]] == '#' }.size
  end

  def print
    puts(@map.map { |line| line.join }.join("\n"))
  end

  def update
    future = @map.map { |line| line.dup }
    future.each_with_index do |line,y|
      line.each_with_index do |_,x|
        bug = self[[x,y]]
        adj = adjacent_bug_count([x,y])
        future[y][x] = if bug == '#' && adj != 1
                          '.'
                        elsif bug == '.' && (adj == 1 || adj == 2)
                          '#'
                        else
                          bug
                        end
      end
    end
    @map = future
  end

  def score
    i = 0
    s = 0
    @map.each_with_index do |line,y|
      line.each_with_index do |bug,x|
        s += 2 ** i if bug == '#'
        i+=1
      end
    end
    s
  end
end

e = Eris.new(<<~MAP)
....#
#..#.
#..##
..#..
#....
MAP

def part1(e)
  scores = Set.new
  e.print
  loop do
    #puts "-----"
    e.update
    #e.print
    s = e.score
    puts s
    if scores.include?(s)
      break
    end
    scores << s
    #sleep(1)
  end
  e.score
end

raise "Failed example1" unless part1(e) == 2129920

e = Eris.new(<<~MAP)
....#
#..#.
##..#
#.###
.####
MAP
puts "Part1: #{part1(e)}"
