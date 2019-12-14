#!/usr/bin/env ruby

require 'pry'

def debug(s)
  puts s if ENV['DEBUG']
end

def debug2(s)
  puts s if ENV['DEBUG2']
end


def read_input(input)
  reactions = {}
  input.split("\n").each do |line|
    i,o = line.split(" => ")
    input_chemicals = i.split(', ').map { |ingredient| read(ingredient) }
    quantity, produced_ingredient = read(o)
    reactions[produced_ingredient] = {produced_quantity: quantity, input_chemicals: input_chemicals }
  end
  reactions
end

def read(ingredient)
  [$1.to_i, $2] if ingredient =~ /^(\d+) (.+)$/
end

def run(recipe, target: 1)
  needs = {}
  needs['FUEL'] = target
  while needs.any? { |ingredient, required| required > 0 && ingredient != 'ORE'}
    debug needs.map { |i,r| "#{i}: #{r}" }.join(', ')
    ingredient, required = needs.find { |i, r| r > 0 && i != 'ORE'}
    reaction_amount = required / recipe[ingredient][:produced_quantity]
    if reaction_amount == 0
      debug "Will produce too much of #{ingredient}"
      reaction_amount = 1
    end
    needs[ingredient] = required - reaction_amount * recipe[ingredient][:produced_quantity]
    recipe[ingredient][:input_chemicals].each do |quantity, input|
      needs[input] ||= 0
      needs[input] += quantity * reaction_amount
    end
  end
  needs['ORE']
end

example1 = read_input(<<~RECIPE)
10 ORE => 10 A
1 ORE => 1 B
7 A, 1 B => 1 C
7 A, 1 C => 1 D
7 A, 1 D => 1 E
7 A, 1 E => 1 FUEL
RECIPE

raise "Failed example1" unless run(example1) == 31

example2 = read_input(<<~RECIPE)
9 ORE => 2 A
8 ORE => 3 B
7 ORE => 5 C
3 A, 4 B => 1 AB
5 B, 7 C => 1 BC
4 C, 1 A => 1 CA
2 AB, 3 BC, 4 CA => 1 FUEL
RECIPE

raise "Failed example2" unless run(example2) == 165

example3 = read_input(<<~RECIPE)
157 ORE => 5 NZVS
165 ORE => 6 DCFZ
44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL
12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ
179 ORE => 7 PSHF
177 ORE => 5 HKGWZ
7 DCFZ, 7 PSHF => 2 XJWVT
165 ORE => 2 GPVTF
3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT
RECIPE

raise "Failed example3" unless run(example3) == 13312


example4 = read_input(<<~RECIPE)
2 VPVL, 7 FWMGM, 2 CXFTF, 11 MNCFX => 1 STKFG
17 NVRVD, 3 JNWZP => 8 VPVL
53 STKFG, 6 MNCFX, 46 VJHF, 81 HVMC, 68 CXFTF, 25 GNMV => 1 FUEL
22 VJHF, 37 MNCFX => 5 FWMGM
139 ORE => 4 NVRVD
144 ORE => 7 JNWZP
5 MNCFX, 7 RFSQX, 2 FWMGM, 2 VPVL, 19 CXFTF => 3 HVMC
5 VJHF, 7 MNCFX, 9 VPVL, 37 CXFTF => 6 GNMV
145 ORE => 6 MNCFX
1 NVRVD => 8 CXFTF
1 VJHF, 6 MNCFX => 4 RFSQX
176 ORE => 6 VJHF
RECIPE

raise "Failed example4" unless run(example4) == 180697

example5 = read_input(<<~RECIPE)
171 ORE => 8 CNZTR
7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL
114 ORE => 4 BHXH
14 VRPVC => 6 BMBT
6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL
6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT
15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW
13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW
5 BMBT => 4 WPTQ
189 ORE => 9 KTJDG
1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP
12 VRPVC, 27 CNZTR => 2 XDBXC
15 KTJDG, 12 BHXH => 5 XCVML
3 BHXH, 2 VRPVC => 7 MZWV
121 ORE => 7 VRPVC
7 XCVML => 6 RJRHP
5 BHXH, 4 VRPVC => 5 LTCX
RECIPE

raise "Failed example5" unless run(example5) == 2210736


input = read_input(<<~RECIPE)
11 BNMWF, 1 MRVFT, 10 PBNSF => 7 XSFVQ
149 ORE => 4 SMSB
1 XHQDX, 1 SVSTJ, 2 LDHX => 7 JMWQG
12 MJCLX => 9 PBNSF
132 ORE => 7 XPTXL
15 TZMWG, 1 LDHX, 1 PDVR => 7 LBQB
1 HJTD, 8 VFXHC => 2 SVSTJ
5 LBHQ, 6 MTQCB => 4 MHBZ
1 PRXT, 1 FWZN => 2 PBMPL
1 XPTXL => 1 HMRGM
10 XHPHR => 6 NSVJL
3 QZQLZ, 3 MTQCB => 4 TZMWG
5 LBHQ, 2 VPSDV => 3 ZFCD
13 WPFP => 6 ZXMGK
10 MHJMX, 75 LDHX, 52 JMWQG, 4 QWRB, 1 SVNVJ, 17 BNMWF, 18 GHVN => 1 FUEL
4 PFQRG, 14 XVNL => 5 PDCV
11 JMWQG, 10 ZBNCP => 6 NTJZH
14 PBMPL, 12 PRXT, 9 MJQS => 9 XVNL
9 GDNG, 13 LBQB => 9 QWRB
1 CXNM => 6 PFQRG
9 NTJZH, 7 BNMWF, 11 JCHP, 1 MHBZ, 1 SVSTJ, 9 XRDN => 5 SVNVJ
1 XHPHR, 1 GSMP => 4 THRVR
26 FWZN => 4 WPFP
35 VJTFJ, 2 XSFVQ, 6 HJVN, 1 NSVJL, 1 JCHP, 3 MJCLX, 1 QZNCK => 6 GHVN
1 WPFP, 3 XHPHR => 2 HJVN
5 SMSB => 7 HNCDS
111 ORE => 4 GSMP
6 LBHQ => 8 GDNG
2 GDNG, 5 MHBZ => 1 RNMKC
15 THRVR, 4 NWNSH, 1 NSVJL => 7 FDVH
2 HMRGM => 9 FWZN
6 MJQS, 5 JRZXM => 5 NWNSH
14 ZXMGK, 1 JTXWX => 6 DLWT
1 MJQS, 3 FWZN, 2 PRXT => 1 JTXWX
1 GSMP, 4 CXNM => 3 JRZXM
151 ORE => 9 ZNPRL
2 NTJZH, 1 DLWT, 3 ZBNCP => 9 MRVFT
14 SWZCB, 1 VPSDV => 7 XRDN
14 LBHQ, 16 FDVH, 9 PFQRG => 4 PRXT
22 CXNM => 9 HJTD
1 VFXHC, 1 MTQCB => 6 QZQLZ
6 SWZCB, 2 PDCV, 17 RNMKC => 9 LTHFW
4 ZNPRL => 6 CXNM
2 CXNM => 3 LBHQ
8 MHBZ, 2 QZQLZ, 2 LBQB => 3 VJTFJ
3 ZFCD => 1 XHQDX
1 VJTFJ, 7 MHBZ => 8 ZBNCP
5 CXNM => 2 VPSDV
7 MJQS => 9 VFXHC
2 LTHFW, 11 HJVN, 4 XRDN, 8 MRVFT, 3 NSVJL, 3 SVSTJ, 5 XSFVQ, 13 RNMKC => 8 MHJMX
2 HMRGM => 3 XHPHR
1 GDNG, 19 PDVR => 3 SWZCB
18 HMRGM, 10 HNCDS => 2 MJQS
6 HNCDS, 2 HMRGM, 1 LBHQ => 3 MTQCB
16 VJTFJ, 1 WPFP, 6 JMWQG => 6 BNMWF
3 TZMWG, 1 FWZN => 7 PDVR
10 ZXMGK => 4 QZNCK
32 LBQB, 1 ZBNCP => 1 JCHP
27 PDVR, 7 QZQLZ, 7 PBMPL => 3 MJCLX
5 MHBZ, 12 ZFCD => 4 LDHX
RECIPE

puts "First part: #{run(input)}"

def dicho(input)
  low_candidate = 1
  candidate = 10
  high_candidate = nil

  loop do
    debug "Trying to produce #{candidate}. Candidate range: [#{low_candidate} #{high_candidate}]"
    ore_required = run(input, target: candidate)
    if ore_required < 1000000000000
      low_candidate = candidate
      candidate *= 2
      debug "Increasing candidate to #{candidate}"
    elsif ore_required > 1000000000000
      high_candidate = candidate
      candidate = (high_candidate + low_candidate) / 2
      debug "Decreasing candidate to #{candidate}"
    else
      return candidate
    end
    if high_candidate && (high_candidate - low_candidate <= 1)
      return low_candidate
    end
  end
end

raise "Failed part2 example5" unless dicho(example5) == 460664
raise "Failed part2 example4" unless dicho(example4) == 5586022
raise "Failed part2 example3" unless dicho(example3) == 82892753

puts "Part2: #{dicho(input)}"
