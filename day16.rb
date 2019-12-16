#!/usr/bin/env ruby

def debug(s)
  puts s if ENV['DEBUG']
end

def debug2(s)
  puts s if ENV['DEBUG2']
end

def input_signal(input)
  input.chars.map(&:to_i)
end

BASE_PATTERN = [0,1,0,-1]

def pattern(position)
  @pattern ||= {}
  @pattern[position] = begin
                         [
                           BASE_PATTERN.map { |el| [el] * position }.flatten.drop(1),
                           BASE_PATTERN.map { |el| [el] * position }.flatten.cycle
                         ].lazy.flat_map(&:lazy)
                       end
end

def phase(input, phase_count)
  current_phase = input_signal(input)
  phase_count.times do
    current_phase = current_phase.each_with_index.map do |el,position|
      current_phase.zip(pattern(position+1)).map { |a,b| a*b }.sum.abs.digits.first.tap do |res|
      debug "=> #{res}"
      end
    end
  end
  current_phase.take(8).join
end

raise "Failed example1" unless "01029498" == phase("12345678",4)
raise "Failed example2" unless "24176176" == phase("80871224585914546619083218645595",100)
raise "Failed example3" unless "73745418" == phase("19617804207202209144916044189917",100)
raise "Failed example4" unless "52432133" == phase("69317163492948606335995924319873",100)

my_input = "59749012692497360857047467554796667139266971954850723493205431123165826080869880148759586023048633544809012786925668551639957826693687972765764376332866751104713940802555266397289142675218037547096634248307260671899871548313611756525442595930474639845266351381011380170903695947253040751698337167594183713030695951696818950161554630424143678657203441568388368475123279525515262317457621810448095399401556723919452322199989580496608898965260381604485810760050252737127446449982328185199195622241930968611065497781555948187157418339240689789877555108205275435831320988202725926797165070246910002881692028525921087207954194585166525017611171911807360959"
puts "First part #{phase(my_input,100)}"
