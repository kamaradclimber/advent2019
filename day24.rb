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
  #e.print
  loop do
    #puts "-----"
    e.update
    #e.print
    s = e.score
    #puts s
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

# part 2
# at minute M, spaces <-M or >M are empty

class ErisR
  def initialize(input)
    map = input.split("\n").map do |line|
      line.chars
    end
    i = 0
    s = 0
    map.each_with_index do |line,y|
      line.each_with_index do |bug,x|
        s += 2 ** i if bug == '#'
        i+=1
      end
    end
    @score = s
  end

  def to_bin(x,y)
    2 ** (y * 5 + x)
  end

  def neighbours(coords)
    x,y = coords
    [[x-1,y],[x+1,y],[x,y-1],[x,y+1]].select do |a,b|
      b>=0 && b < 5 && a >= 0 && a < 5
    end.map { |a,b| to_bin(a,b) }
  end

  def adjacent_bug_count(coords)
    neighbours(coords).sum & @score
  end

  def update
    new_score = 0
    25.times do |index|
      x,y = index % 5, index / 5
      adj = adjacent_bug_count([x,y])
      poweroftwo = adj != 0 && adj & (adj - 1) == 0
      if @score & 2**index == 0 # there was no bug
        adjp = adj & (adj - 1)
        sumpoweroftwo = adjp !=0 && adjp & (adjp-1) == 0
        new_score += 2**index if sumpoweroftwo || poweroftwo
      else
        new_score += 2**index if poweroftwo
      end
    end
    @score = new_score
  end

  def score
    @score
  end

  def print
  end
end

class ErisRR
  def initialize(draw: nil,recuring:, my_level:, score: nil)
    @recursive = recuring
    @my_level = my_level
    if draw
      map = draw.split("\n").map do |line|
        line.chars
      end
      i = 0
      s = 0
      map.each_with_index do |line,y|
        line.each_with_index do |bug,x|
          s += 2 ** i if bug == '#'
          i+=1
        end
      end
      @score = s
    else
      @score = score
    end
  end

  def to_bin(x,y)
    2 ** (y * 5 + x)
  end

  def adjacent_bug_count(coords)
    x,y = coords
    neigh = [[x-1,y],[x+1,y],[x,y-1],[x,y+1]].select do |a,b|
      b>=0 && b < 5 && a >= 0 && a < 5 && [a,b] != [2,2]
    end.map { |a,b| to_bin(a,b) }
    count = neigh.sum & @score
    count = count << 24
    #binding.pry if @my_level == 0 && [x,y] == [2,0]
    count += @recursive.levels[@my_level - 1].score & 2**11 if x ==0
    count += @recursive.levels[@my_level - 1].score & 2**13 if x == 4
    count += @recursive.levels[@my_level - 1].score & 2**7 if y ==0
    count += @recursive.levels[@my_level - 1].score & 2**17 if y==4

    count += @recursive.levels[@my_level + 1].score & 31 if [x,y] == [2,1]
    count += @recursive.levels[@my_level + 1].score & 17318416  if [x,y] == [3,2]
    count += @recursive.levels[@my_level + 1].score & 1082401 if [x,y] == [1,2]
    count += @recursive.levels[@my_level + 1].score & 32505856 if [x,y] == [2,3]
    count
  end

  def update
    new_score = 0
    25.times do |index|
      next if index == 12
      x,y = index % 5, index / 5
      adj = adjacent_bug_count([x,y])
      poweroftwo = adj != 0 && adj & (adj - 1) == 0
      if @score & 2**index == 0 # there was no bug
        adjp = adj & (adj - 1)
        sumpoweroftwo = adjp !=0 && adjp & (adjp-1) == 0
        new_score += 2**index if sumpoweroftwo || poweroftwo
      else
        new_score += 2**index if poweroftwo
      end
    end
    new_score
  end

  def score
    @score
  end

  def print
    lines = @score.to_s(2).chars.reverse.each_slice(5).to_a
    lines[-1] = lines.last + [0] * (5 - lines.last.size)
    lines << [0] * 5 until lines.size == 5
    puts lines.map(&:join).join("\n")
  end
end

e = ErisR.new(<<~MAP)
....#
#..#.
#..##
..#..
#....
MAP
raise "Failed optimized example1" unless part1(e) == 2129920

class RecursiveEris
  attr_reader :levels

  def initialize(input)
    @levels = Hash.new do |h,k|
      h[k] = ErisRR.new(draw: (["....."] * 5).join("\n"),recuring: self,my_level: k)
    end
    @levels[0] = ErisRR.new(draw: input,recuring: self,my_level: 0)
  end

  def update(level_range)
    new_levels = @levels.dup
    level_range.each do |level_i|
    new_levels[level_i] = ErisRR.new(score: @levels[level_i].update, recuring: self,my_level: level_i)
    end
    @levels = new_levels
  end

  def print(range)
    range.each do |i|
      puts "Level #{i}"
      @levels[i].print
    end
  end

  def n_updates(n)
    #print(0..0)
    n.times do |i|
      min = @levels.select { |_,lev| lev.score > 0 }.keys.min - 1
      max = @levels.select { |_,lev| lev.score > 0 }.keys.max + 1
      #puts "Simulating minute #{i+1}: #{min..max}"
      update(min..max)
      #print(min..max)
      #binding.pry
    end
    @levels.map do |_,eris|
      eris.score.to_s(2).chars.map(&:to_i).sum
    end.sum
  end
end

re = RecursiveEris.new(<<~MAP)
....#
#..#.
#.?##
..#..
#....
MAP
raise "Failed example2" unless 99 == re.n_updates(10)

re = RecursiveEris.new(<<~MAP)
....#
#..#.
##..#
#.###
.####
MAP
puts "Part 2 : #{re.n_updates(1000)}"
