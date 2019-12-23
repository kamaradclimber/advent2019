#!/usr/bin/env ruby


require 'pry'

def debug!
  ENV['DEBUG1'] = ''
end

def debug?
  ENV['DEBUG1']
end

class Cards
  attr_reader :deck

  def initialize(size)
    @deck = (0...size).to_a
  end

  def deal
    @deck = @deck.reverse
    self
  end

  def cut(n)
    if n >= 0
      top = @deck.take(n)
      bottom = @deck.drop(n)
      @deck = bottom + top
    else
      cut(deck.size - n.abs)
    end
    self
  end

  def deal_with(n)
    new_deck = [nil] * deck.size
    index = 0
    until new_deck.all?
      raise "card already present at index #{index} (#{index%new_deck.size}): #{deck.first}" if new_deck[index % new_deck.size]
      new_deck[index % new_deck.size] = deck.shift
      index+=n
    end
    @deck = new_deck
    self
  end

  def apply(line)
    case line
    when /deal with increment (.+)/
      deal_with($1.to_i)
    when /deal into new stack/
      deal
    when /cut (.+)/
      cut($1.to_i)
    end
  end
end

puts Cards.new(10).cut(3).deck == [3, 4, 5, 6, 7, 8, 9, 0, 1, 2]
puts Cards.new(10).cut(-4).deck == [6, 7, 8, 9, 0, 1, 2, 3, 4, 5]

puts Cards.new(10).deal_with(3).deck == [0, 7, 4, 1, 8, 5, 2, 9, 6, 3]


deck = Cards.new(10)
example1 = <<~EX
deal with increment 7
deal into new stack
deal into new stack
EX

example1
  .split("\n")
  .map {|l| deck.apply(l) }
  
puts deck.deck == [0, 3, 6, 9, 2, 5, 8, 1, 4, 7]


deck = Cards.new(10)
example4 = <<~EX
deal into new stack
cut -2
deal with increment 7
cut 8
cut -4
deal with increment 7
cut 3
deal with increment 9
deal with increment 3
cut -1
EX

example4
  .split("\n")
  .map {|l| deck.apply(l) }
  
puts deck.deck == [9, 2, 5, 8, 1, 4, 7, 0, 3, 6]


deck = Cards.new(10007)
part1 = <<~EX
cut 3334
deal into new stack
deal with increment 4
cut -342
deal with increment 30
cut -980
deal into new stack
cut -8829
deal with increment 10
cut -7351
deal with increment 60
cut -3766
deal with increment 52
cut 8530
deal with increment 35
cut -6979
deal with increment 52
cut -8287
deal with increment 34
cut -6400
deal with increment 24
deal into new stack
deal with increment 28
cut 7385
deal with increment 32
cut -1655
deal with increment 66
cut -2235
deal with increment 40
cut 8121
deal with increment 71
cut -2061
deal with increment 73
cut 7267
deal with increment 19
cut 2821
deal with increment 16
cut 7143
deal into new stack
deal with increment 31
cut 695
deal with increment 26
cut 9140
deal with increment 73
cut -4459
deal with increment 17
cut 9476
deal with increment 70
cut -9832
deal with increment 46
deal into new stack
deal with increment 62
cut 6490
deal with increment 29
cut 3276
deal into new stack
cut 6212
deal with increment 9
cut -2826
deal into new stack
cut -1018
deal into new stack
cut -9257
deal with increment 39
cut 4023
deal with increment 69
cut -8818
deal with increment 74
cut -373
deal with increment 51
cut 3274
deal with increment 38
cut 1940
deal into new stack
cut -3921
deal with increment 3
cut -8033
deal with increment 38
cut 6568
deal into new stack
deal with increment 68
deal into new stack
deal with increment 70
cut -9
deal with increment 32
cut -9688
deal with increment 4
deal into new stack
cut -1197
deal with increment 54
cut -582
deal into new stack
cut -404
deal into new stack
cut -8556
deal with increment 47
cut 7318
deal with increment 38
cut -8758
deal with increment 48
EX

#debug!
#part1
#  .split("\n")
#  .map {|l| deck.apply(l) }
#  
#puts deck.deck.index(2019)

class Cards2
  attr_reader :index_to_track
  def initialize(size, index_to_track)
    @size = size
    @index_to_track = index_to_track
    @inv = {}
  end

  def rev_deal
    @index_to_track = @size - 1 - @index_to_track
    self
  end

  def rev_cut(n)
    if n >= 0
      if @index_to_track < @size - n
        @index_to_track += n
      else
        @index_to_track -= @size - n
      end
    else
      rev_cut(@size - n.abs)
    end
    self
  end

  def rev_deal_with(n)
    @inv[n] ||= begin
                  r,u,_ = euclide(n)
                  raise "GCD is not 1 ???" unless r == 1
                  u
                end
    @index_to_track = (@inv[n] * @index_to_track ) % @size
  end

  def euclide(b)
    a = @size
    r, u, v, rp, up, vp = a, 1, 0, b, 0, 1
    while rp != 0
      q = r / rp
      r, u, v, rp, up, vp = rp, up, vp, (r - q*rp), (u - q*up), (v - q*vp)
    end
    [r,u,v]
  end

  def apply(line)
    case line
    when /deal with increment (.+)/
      rev_deal_with($1.to_i)
    when /deal into new stack/
      rev_deal
    when /cut (.+)/
      rev_cut($1.to_i)
    end
  end
end

deck = Cards2.new(119315717514047, 2020)
require 'set'
indices = Set.new
indices << 2020

101741582076661.times do |i|
  if i % 1000 == 0
    puts i
    puts deck.index_to_track
  end
  part1
    .split("\n")
    .reverse
    .map {|l| deck.apply(l) }
  if indices.include?(deck.index_to_track)
    binding.pry
  end
  indices << deck.index_to_track
end

puts deck.index_to_track
