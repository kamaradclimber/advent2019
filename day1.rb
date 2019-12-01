#!/usr/bin/env ruby

def fuel(mass)
  mass / 3 - 2
end

raise "Error example 12" unless fuel(12) == 2
raise "Error example 14" unless fuel(14) == 2
raise "Error example 1969" unless fuel(1969) == 654
raise "Error example 100756" unless fuel(100756) == 33583

input = DATA.read.split("\n").map(&:to_i)

first_step = input.map { |mod| fuel(mod) }.sum
puts "First step: #{first_step}"

def total_fuel_computation(first_step)
  total_fuel = 0
  extra_fuel = first_step
  loop do
    extra = fuel(extra_fuel)
    break unless extra > 0
    total_fuel += extra
    extra_fuel = extra
    #puts "extra: #{extra_fuel}, total: #{total_fuel}"
  end
  total_fuel
end

raise "Error example 1969" unless total_fuel_computation(1969) == 966
raise "Error example 100756" unless total_fuel_computation(100756) == 50346

second_step = input.map { |mod| total_fuel_computation(mod) }.sum
puts "Second step: #{second_step}"

__END__
74819
111192
104476
53965
89875
147914
120203
73658
80054
75468
88811
73140
90128
51639
70417
102818
106523
77151
118711
146183
143477
89008
67987
94512
98199
118483
91978
53595
144819
130211
103326
113805
50204
138909
113345
142697
121281
128132
98383
127929
88562
135418
65123
94330
107136
85822
86208
93398
110176
143538
98851
56280
84734
52873
51898
66332
91624
75662
125892
137867
114748
124360
81075
140638
77417
86881
50250
131326
88877
141095
147701
103934
101008
140186
117845
149923
138631
93188
74299
89504
75185
72688
53057
50200
124950
110233
114558
94047
112376
122374
115571
136289
115146
80924
140787
125638
99960
61024
138366
127943
