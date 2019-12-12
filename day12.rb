#!/usr/bin/env ruby

def debug(s)
  puts s if ENV['DEBUG']
end

def debug2(s)
  puts s if ENV['DEBUG2']
end

class Moon
  attr_reader :pos, :velocity

  def initialize(x:,y:,z:)
    @pos = [x,y,z]
    @velocity = [0,0,0]
  end

  def apply_gravity(other)
    vx,vy,vz = @velocity
    x1,y1,z1 = self.pos
    x2,y2,z2 = other.pos
    vx -= x1 <=> x2
    vy -= y1 <=> y2
    vz -= z1 <=> z2
    @velocity = [vx,vy,vz]
  end

  def update_pos
    x1,y1,z1 = self.pos
    vx,vy,vz = @velocity
    @pos = [x1+vx, y1+vy,z1+vz]
  end

  def energy_detail
    [pos.map(&:abs).sum, @velocity.map(&:abs).sum]
  end

  def energy
    pos.map(&:abs).sum * @velocity.map(&:abs).sum
  end
end

def round(moons)
  moons.permutation(2).each do |m1,m2|
    m1.apply_gravity(m2)
  end
  moons.each { |moon| moon.update_pos }
  moons.each_with_index { |moon,i| debug "#{i} #{moon.pos.join(':')}" }
end

def parse(input)
  input.split("\n").map do |line|
    if line =~ /<x=(.+), y=(.+), z=(.+)>/
      Moon.new(x: $1.to_i,y: $2.to_i, z: $3.to_i)
    end
  end
end

example1 = parse(<<~MOONS)
<x=-1, y=0, z=2>
<x=2, y=-10, z=-7>
<x=4, y=-8, z=8>
<x=3, y=5, z=-1>
MOONS
10.times do round(example1) end
raise "Failed example1" unless 179 == example1.map(&:energy).sum

example2 = parse(<<~MOONS)
<x=-8, y=-10, z=0>
<x=5, y=5, z=10>
<x=2, y=-7, z=3>
<x=9, y=-8, z=-3>
MOONS
100.times do round(example2) end
raise "Failed example2" unless 1940 == example2.map(&:energy).sum

input = parse(<<~MOONS)
<x=8, y=0, z=8>
<x=0, y=-5, z=-10>
<x=16, y=10, z=-5>
<x=19, y=-10, z=-7>
MOONS
1000.times do round(input) end
puts "First part: #{input.map(&:energy).sum}"

def checksum(moons, dimension)
  moons.map do |moon|
    [moon.pos[dimension], moon.velocity[dimension]]
  end.flatten.join(',')
end


example1 = parse(<<~MOONS)
<x=-1, y=0, z=2>
<x=2, y=-10, z=-7>
<x=4, y=-8, z=8>
<x=3, y=5, z=-1>
MOONS

def recurence(moons)
  known_pos = {0 => {},1 => {}, 2 => {}}
  known_frequency = {}
  step = 0
  loop do
    #puts "Step #{step}"
    3.times do |dimension|
      check = checksum(moons, dimension)
      if known_pos[dimension].key?(check) && !known_frequency.key?(dimension)
        debug "Found recurrence on dimension #{dimension}: #{step - known_pos[dimension][check]}"
        known_frequency[dimension] = [known_pos[dimension][check], step - known_pos[dimension][check]]
      else
        known_pos[dimension][check] = step
      end
    end
    break if known_frequency.size == 3
    step += 1
    round(moons)
  end
  raise "Wrong assumption about cycle starting at step 0" unless known_frequency.values.map(&:first).all?(&:zero?)
  known_frequency.values.map { |f| f[1] }.inject { |mem, el| mem.lcm(el) }
end

raise "Wrong example1" unless recurence(example1) == 2772

example2 = parse(<<~MOONS)
<x=-8, y=-10, z=0>
<x=5, y=5, z=10>
<x=2, y=-7, z=3>
<x=9, y=-8, z=-3>
MOONS
raise "Wrong example2" unless recurence(example2) == 4686774924

input = parse(<<~MOONS)
<x=8, y=0, z=8>
<x=0, y=-5, z=-10>
<x=16, y=10, z=-5>
<x=19, y=-10, z=-7>
MOONS
puts "Second part: #{recurence(input)}"
