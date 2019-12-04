#!/usr/bin/env ruby

range = DATA.read.split("\n").first.split('-').map(&:to_i)

def valid?(password, part2: false)
  unless password.to_s.size == 6
    puts "Wrong size #{password}" if ENV['DEBUG']
    return false
  end
  s = password.to_s
  is = s.chars.map(&:to_i)
  unless (0..4).any? { |i| s[i] == s[i+1] }
    puts "No duplicate #{password}" if ENV['DEBUG']
    return false
  end
  if part2
    unless (0..4).any? do |i|
      next unless s[i] == s[i+1]
      next if i > 0 && s[i-1] == s[i] 
      next if i < 4 && s[i+2] == s[i+1] 
      true
    end
      puts "No duplicate with only two consecutive digits #{password}" if ENV['DEBUG']
      return false
    end
  end
  unless (0..4).all? { |i| is[i] <= is[i+1] }
    puts "Not increasing #{password}" if ENV['DEBUG'] 
    return false
  end
  true
end

raise unless valid?(111111)
raise if valid?(223450)
raise if valid?(123789)

puts (range[0]..range[1]).count { |i| valid?(i) }

raise unless valid?(112233, part2: true)
raise if valid?(123444, part2: true)
raise unless valid?(111122, part2: true)
puts (range[0]..range[1]).count { |i| valid?(i, part2: true) }

__END__
128392-643281
