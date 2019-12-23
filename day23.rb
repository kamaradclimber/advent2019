#!/usr/bin/env ruby

require 'pry'

DATA = "3,62,1001,62,11,10,109,2225,105,1,0,1371,765,990,955,2039,571,1206,2136,1447,1021,1103,1641,1412,1915,1134,1307,1975,1476,1707,1610,924,1816,2165,734,827,2004,1577,1169,1540,2099,1884,670,858,701,798,2194,1851,602,1340,1070,891,1738,1944,633,1672,1505,2068,1775,1237,1270,0,0,0,0,0,0,0,0,0,0,0,0,3,64,1008,64,-1,62,1006,62,88,1006,61,170,1106,0,73,3,65,20101,0,64,1,21002,66,1,2,21102,1,105,0,1105,1,436,1201,1,-1,64,1007,64,0,62,1005,62,73,7,64,67,62,1006,62,73,1002,64,2,132,1,132,68,132,1002,0,1,62,1001,132,1,140,8,0,65,63,2,63,62,62,1005,62,73,1002,64,2,161,1,161,68,161,1102,1,1,0,1001,161,1,169,1002,65,1,0,1101,0,1,61,1101,0,0,63,7,63,67,62,1006,62,203,1002,63,2,194,1,68,194,194,1006,0,73,1001,63,1,63,1105,1,178,21101,0,210,0,105,1,69,2101,0,1,70,1101,0,0,63,7,63,71,62,1006,62,250,1002,63,2,234,1,72,234,234,4,0,101,1,234,240,4,0,4,70,1001,63,1,63,1105,1,218,1105,1,73,109,4,21102,0,1,-3,21102,1,0,-2,20207,-2,67,-1,1206,-1,293,1202,-2,2,283,101,1,283,283,1,68,283,283,22001,0,-3,-3,21201,-2,1,-2,1106,0,263,22101,0,-3,-3,109,-4,2105,1,0,109,4,21101,0,1,-3,21102,0,1,-2,20207,-2,67,-1,1206,-1,342,1202,-2,2,332,101,1,332,332,1,68,332,332,22002,0,-3,-3,21201,-2,1,-2,1105,1,312,21201,-3,0,-3,109,-4,2106,0,0,109,1,101,1,68,358,21002,0,1,1,101,3,68,366,21001,0,0,2,21101,0,376,0,1105,1,436,22102,1,1,0,109,-1,2105,1,0,1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192,16384,32768,65536,131072,262144,524288,1048576,2097152,4194304,8388608,16777216,33554432,67108864,134217728,268435456,536870912,1073741824,2147483648,4294967296,8589934592,17179869184,34359738368,68719476736,137438953472,274877906944,549755813888,1099511627776,2199023255552,4398046511104,8796093022208,17592186044416,35184372088832,70368744177664,140737488355328,281474976710656,562949953421312,1125899906842624,109,8,21202,-6,10,-5,22207,-7,-5,-5,1205,-5,521,21101,0,0,-4,21102,1,0,-3,21102,1,51,-2,21201,-2,-1,-2,1201,-2,385,471,20101,0,0,-1,21202,-3,2,-3,22207,-7,-1,-5,1205,-5,496,21201,-3,1,-3,22102,-1,-1,-5,22201,-7,-5,-7,22207,-3,-6,-5,1205,-5,515,22102,-1,-6,-5,22201,-3,-5,-3,22201,-1,-4,-4,1205,-2,461,1106,0,547,21101,-1,0,-4,21202,-6,-1,-6,21207,-7,0,-5,1205,-5,547,22201,-7,-6,-7,21201,-4,1,-4,1106,0,529,21202,-4,1,-7,109,-8,2105,1,0,109,1,101,1,68,564,20101,0,0,0,109,-1,2105,1,0,1101,51263,0,66,1101,0,1,67,1101,0,598,68,1101,0,556,69,1102,1,1,71,1101,600,0,72,1105,1,73,1,-159,21,138783,1101,76387,0,66,1102,1,1,67,1101,0,629,68,1101,0,556,69,1102,1,1,71,1101,631,0,72,1105,1,73,1,197,44,271419,1101,19391,0,66,1102,1,4,67,1102,1,660,68,1102,302,1,69,1102,1,1,71,1101,0,668,72,1105,1,73,0,0,0,0,0,0,0,0,47,5942,1101,0,41777,66,1102,1,1,67,1101,697,0,68,1101,556,0,69,1102,1,1,71,1101,0,699,72,1106,0,73,1,16,28,105159,1102,68473,1,66,1101,2,0,67,1101,728,0,68,1102,1,302,69,1101,0,1,71,1101,732,0,72,1105,1,73,0,0,0,0,41,60796,1102,4157,1,66,1102,1,1,67,1102,1,761,68,1102,1,556,69,1101,1,0,71,1101,0,763,72,1106,0,73,1,160,47,11884,1102,38287,1,66,1101,0,2,67,1102,1,792,68,1101,351,0,69,1102,1,1,71,1101,0,796,72,1106,0,73,0,0,0,0,255,1151,1102,82763,1,66,1102,1,1,67,1102,825,1,68,1101,0,556,69,1102,1,0,71,1101,827,0,72,1105,1,73,1,1854,1102,1,41579,66,1101,0,1,67,1102,1,854,68,1101,556,0,69,1101,0,1,71,1102,1,856,72,1106,0,73,1,107,27,211467,1102,1,34157,66,1102,1,1,67,1102,1,885,68,1102,556,1,69,1102,2,1,71,1101,0,887,72,1105,1,73,1,269,27,70489,21,46261,1101,0,33469,66,1102,2,1,67,1102,918,1,68,1102,1,302,69,1101,0,1,71,1102,922,1,72,1105,1,73,0,0,0,0,39,80378,1102,48259,1,66,1101,0,1,67,1102,951,1,68,1101,556,0,69,1101,0,1,71,1101,953,0,72,1106,0,73,1,2971,29,149588,1101,90359,0,66,1101,0,3,67,1102,982,1,68,1102,302,1,69,1101,0,1,71,1102,1,988,72,1105,1,73,0,0,0,0,0,0,41,30398,1102,29669,1,66,1102,1,1,67,1101,0,1017,68,1101,0,556,69,1102,1,1,71,1102,1019,1,72,1106,0,73,1,1187,45,143722,1101,0,11071,66,1101,0,1,67,1101,0,1048,68,1101,556,0,69,1102,10,1,71,1101,0,1050,72,1106,0,73,1,1,12,233319,45,71861,44,180946,28,70106,48,36599,40,66938,39,40189,26,32986,29,74794,21,92522,1102,1,40189,66,1102,2,1,67,1102,1,1097,68,1101,302,0,69,1101,0,1,71,1102,1,1101,72,1105,1,73,0,0,0,0,26,16493,1102,1,48571,66,1101,1,0,67,1101,0,1130,68,1101,0,556,69,1102,1,1,71,1102,1132,1,72,1105,1,73,1,881,28,140212,1102,44987,1,66,1102,3,1,67,1102,1,1161,68,1101,302,0,69,1101,0,1,71,1102,1,1167,72,1105,1,73,0,0,0,0,0,0,41,45597,1101,0,70489,66,1101,0,4,67,1102,1196,1,68,1101,302,0,69,1102,1,1,71,1101,1204,0,72,1105,1,73,0,0,0,0,0,0,0,0,41,15199,1101,41161,0,66,1101,0,1,67,1102,1,1233,68,1101,0,556,69,1101,1,0,71,1102,1235,1,72,1105,1,73,1,20,12,155546,1101,0,36599,66,1101,2,0,67,1101,1264,0,68,1101,302,0,69,1101,0,1,71,1101,0,1268,72,1106,0,73,0,0,0,0,40,33469,1101,29759,0,66,1101,4,0,67,1102,1297,1,68,1101,0,253,69,1101,1,0,71,1101,1305,0,72,1106,0,73,0,0,0,0,0,0,0,0,27,140978,1102,60169,1,66,1101,1,0,67,1101,1334,0,68,1102,556,1,69,1101,2,0,71,1102,1,1336,72,1105,1,73,1,10,43,19391,47,14855,1102,1,88873,66,1101,0,1,67,1101,0,1367,68,1101,556,0,69,1101,0,1,71,1101,1369,0,72,1105,1,73,1,23203,48,73198,1102,1151,1,66,1101,0,1,67,1102,1,1398,68,1101,0,556,69,1102,6,1,71,1102,1400,1,72,1106,0,73,1,24073,33,68473,14,44987,14,89974,3,90359,3,180718,3,271077,1102,1,77773,66,1101,0,3,67,1102,1439,1,68,1101,302,0,69,1101,0,1,71,1101,1445,0,72,1106,0,73,0,0,0,0,0,0,49,89277,1102,7253,1,66,1101,0,1,67,1102,1,1474,68,1102,556,1,69,1102,0,1,71,1102,1,1476,72,1106,0,73,1,1335,1101,88997,0,66,1102,1,1,67,1102,1503,1,68,1102,1,556,69,1101,0,0,71,1102,1,1505,72,1105,1,73,1,1025,1102,71861,1,66,1101,3,0,67,1101,0,1532,68,1102,302,1,69,1102,1,1,71,1101,1538,0,72,1105,1,73,0,0,0,0,0,0,49,29759,1102,35053,1,66,1102,1,4,67,1102,1567,1,68,1102,302,1,69,1101,1,0,71,1101,1575,0,72,1106,0,73,0,0,0,0,0,0,0,0,49,119036,1101,0,16493,66,1102,2,1,67,1102,1,1604,68,1102,1,302,69,1101,1,0,71,1101,0,1608,72,1106,0,73,0,0,0,0,29,37397,1102,1,8059,66,1102,1,1,67,1101,0,1637,68,1101,556,0,69,1101,0,1,71,1102,1639,1,72,1105,1,73,1,19,29,112191,1101,0,30557,66,1102,1,1,67,1101,0,1668,68,1102,1,556,69,1101,1,0,71,1101,1670,0,72,1106,0,73,1,61,28,35053,1102,90473,1,66,1102,3,1,67,1101,0,1699,68,1101,302,0,69,1101,0,1,71,1102,1705,1,72,1106,0,73,0,0,0,0,0,0,49,59518,1102,1,24371,66,1102,1,1,67,1101,0,1734,68,1102,1,556,69,1101,0,1,71,1101,1736,0,72,1105,1,73,1,-49,45,215583,1102,15199,1,66,1101,4,0,67,1101,0,1765,68,1101,0,253,69,1102,1,1,71,1101,0,1773,72,1105,1,73,0,0,0,0,0,0,0,0,1,38287,1102,1,2971,66,1101,0,6,67,1101,0,1802,68,1102,1,302,69,1101,0,1,71,1102,1814,1,72,1105,1,73,0,0,0,0,0,0,0,0,0,0,0,0,1,76574,1101,0,46261,66,1102,1,3,67,1102,1,1843,68,1102,302,1,69,1101,0,1,71,1101,0,1849,72,1106,0,73,0,0,0,0,0,0,14,134961,1101,15791,0,66,1102,1,1,67,1102,1,1878,68,1102,556,1,69,1101,2,0,71,1101,1880,0,72,1106,0,73,1,2,47,2971,47,8913,1101,0,75689,66,1102,1,1,67,1102,1,1911,68,1102,556,1,69,1102,1,1,71,1102,1913,1,72,1105,1,73,1,53,27,281956,1101,0,4651,66,1102,1,1,67,1101,0,1942,68,1102,556,1,69,1101,0,0,71,1102,1,1944,72,1105,1,73,1,1168,1101,0,16073,66,1102,1,1,67,1102,1971,1,68,1102,556,1,69,1101,1,0,71,1102,1,1973,72,1106,0,73,1,125,43,77564,1102,6551,1,66,1102,1,1,67,1101,0,2002,68,1101,0,556,69,1101,0,0,71,1101,0,2004,72,1106,0,73,1,1830,1101,14369,0,66,1101,0,1,67,1101,2031,0,68,1101,0,556,69,1102,1,3,71,1101,0,2033,72,1105,1,73,1,5,43,38782,43,58173,47,17826,1102,18371,1,66,1102,1,1,67,1102,1,2066,68,1101,0,556,69,1101,0,0,71,1102,2068,1,72,1105,1,73,1,1871,1101,71453,0,66,1102,1,1,67,1102,2095,1,68,1102,1,556,69,1102,1,1,71,1102,1,2097,72,1105,1,73,1,-60,44,90473,1101,0,37397,66,1102,4,1,67,1102,1,2126,68,1101,0,302,69,1102,1,1,71,1102,1,2134,72,1105,1,73,0,0,0,0,0,0,0,0,33,136946,1102,1,51787,66,1102,1,1,67,1101,2163,0,68,1102,1,556,69,1101,0,0,71,1102,2165,1,72,1106,0,73,1,1345,1101,7877,0,66,1102,1,1,67,1101,0,2192,68,1101,0,556,69,1102,1,0,71,1101,0,2194,72,1105,1,73,1,1215,1102,1,72493,66,1102,1,1,67,1101,2221,0,68,1101,556,0,69,1102,1,1,71,1102,1,2223,72,1105,1,73,1,5711,12,77773"
input = DATA.split(',').map(&:to_i)
input_copy = input.dup

def debug(s)
  puts s if ENV['DEBUG']
end

def debug2(s)
  puts s if ENV['DEBUG2']
  STDOUT.flush
end
def debug4(s)
  puts s if ENV['DEBUG4']
  STDOUT.flush
end

def read_param(param_mode, input, index, relative_base)
  case param_mode
  when 0 # position mode
    debug "Reading param at index #{index} in position mode, points to index #{input[index]}, value #{input[input[index]]}"
    input[input[index]]
  when 1
    debug "Reading param at index #{index} in immediate mode, value #{input[index]}"
    input[index]
  when 2
    debug "Reading param at index #{index} in relative mode, points to index #{input[relative_base + input[index]]}, value #{input[input[relative_base + input[index]]]}"
    input[relative_base + input[index]]
  else
    raise "Unknown param_mode #{param_mode}"
  end
end

def write_param(param_mode, input, index, relative_base, value)
  case param_mode
  when 0
    debug "Writing value #{value} in position mode at index #{index}, points to index #{input[index]}, previous value #{input[input[index]]}"
    input[input[index]] = value
  when 1
    raise "Cannot use immediate mode to write!"
  when 2
    debug "Writing value #{value} in relative mode at index #{index}, points to index #{input[index] + relative_base}, previous value #{input[input[index] + relative_base]}"
    input[input[index] + relative_base] = value
  else
    raise "Unknown param_mode #{param_mode} to write param"
  end
end

def read_next(input, index, intake)
  puts input[index..(index + intake - 1)].join(' ') if ENV['DEBUG']
end

def step(index, input, params)
  relative_base = params[:relative_base]
  stdin = params[:stdin]
  stdout = params[:stdout]
  opcode = input[index] % 100
  modes = (input[index] / 100).digits + [0] * 3 # extend modes with enough 0s
  read_next(input, index, 8)
  print "Opcode is #{opcode} " if ENV['DEBUG']
  case opcode
  when 1
    debug 'addition'

    old_value = input[input[index + 3]]
    value = read_param(modes[0], input, index + 1, relative_base) + read_param(modes[1], input, index + 2, relative_base)
    write_param(modes[2], input, index+3, relative_base, value)
    # puts input.join(",") if ENV['DEBUG']
    4
  when 2
    debug 'multiplication'

    value = read_param(modes[0], input, index + 1, relative_base) * read_param(modes[1], input, index + 2, relative_base)
    write_param(modes[2], input, index+3, relative_base, value)
    # puts input.join(",") if ENV['DEBUG']
    4
  when 3
    debug 'stdin'
    raise 'Already consumed stdin' if stdin.empty? && stdin.is_a?(Array)

    old_value = input[input[index + 1]]
    write_param(modes[0], input, index+1, relative_base, stdin.pop)
    # puts input.join(",") if ENV['DEBUG']
    2
  when 4
    debug 'stdout'
    stdout << read_param(modes[0], input, index + 1, relative_base)
    #debug "STDOUT: #{stdout.join(',')}"
    2
  when 5
    debug 'jump-if-true'
    if read_param(modes[0], input, index + 1, relative_base) != 0
      puts "Jumping to #{read_param(modes[1], input, index + 2, relative_base)}" if ENV['DEBUG']
      # puts input.join(",") if ENV['DEBUG']
      read_param(modes[1], input, index + 2, relative_base) - index
    else
      puts 'Not jumping' if ENV['DEBUG']
      3
    end
  when 6
    debug 'jump-if-false'
    if read_param(modes[0], input, index + 1, relative_base) == 0
      puts "Jumping to #{read_param(modes[1], input, index + 2, relative_base)}" if ENV['DEBUG']
      # puts input.join(",") if ENV['DEBUG']
      read_param(modes[1], input, index + 2, relative_base) - index
    else
      puts 'Not jumping' if ENV['DEBUG']
      3
    end
  when 7
    debug 'lower-than'

    a = read_param(modes[0], input, index + 1, relative_base)
    b = read_param(modes[1], input, index + 2, relative_base)
    value = a < b ? 1 : 0
    write_param(modes[2], input, index+3, relative_base, value)
    # puts input.join(",") if ENV['DEBUG']
    # puts input.join(",") if ENV['DEBUG']
    4
  when 8
    debug 'equal'

    a = read_param(modes[0], input, index + 1, relative_base)
    b = read_param(modes[1], input, index + 2, relative_base)
    value = a == b ? 1 : 0
    write_param(modes[2], input, index+3, relative_base, value)
    # puts input.join(",") if ENV['DEBUG']
    4
  when 9
    debug 'change of relative base offset'

    params[:relative_base] += read_param(modes[0], input, index + 1, relative_base)
    2
  when 99
    debug 'Halt!' if ENV['DEBUG']
    # puts input.join(",") if ENV['DEBUG']
    debug2 "Halt!!"
    false
  else
    raise "Error with unknown opcode #{opcode} at #{index}"
  end
end

class ExtensibleArray
  def initialize(array)
    @h = {}
    array.each_with_index do |el,index|
      @h[index] = el
    end
  end

  def [](a)
    case a
    when Integer
      if @h.key?(a)
        @h[a]
      else
        0
      end
    when Range
      (a.begin..a.end).map { |i| self[i] }
    else
      raise "Unknown input type for ExtensibleArray"
    end
  end

  def []=(a,b)
    @h[a] = b
  end
end

def iterate(input, stdin: [], stdout: [])
  params = { stdin: stdin, stdout: stdout, relative_base: 0 }
  # puts input.join(",") if ENV['DEBUG']
  i = 0
  increment = 0
  input = ExtensibleArray.new(input)
  while (increment = step(i, input, params))
    puts "Moving cursor from #{i} to #{i + increment}" if ENV['DEBUG']
    i += increment
  end
  input
end

class Routing
  def initialize
    @queues = Hash.new do |h,k|
      h[k] = []
    end
    @idle = Hash.new(0)
    @lock = Mutex.new
  end

  def queue(i)
    @queues[i]
  end

  def send(origin, dest, coords)
    @idle[origin] = 0 if origin.is_a?(Integer)
    if dest == 255
      puts "First part #{coords[1]}" unless @first_part
      @memory = coords
      @first_part = true
    else
      q = queue(dest)
      q << coords
    end
  end

  def receive(i)
    q = queue(i)
    if q.empty?
      @idle[i] += 1
      if idle?
        @lock.synchronize do 
          idle_action if idle?
        end
      end
      sleep(0.01)
      nil
    else
      debug4 "#{i} receiving a packet"
      @idle[i] = 0
      q.shift
    end
  end

  def idle?
    return false unless @queues.dup.values.all?(&:empty?)
    min_idle = @idle.dup.values.min
    return true if min_idle > 3
    false
  end

  def idle_action
    return unless @memory
    puts "Doing idle action: #{@memory.join(',')}"
    send("NAT", 0, @memory)
    if @memory && @prev_send == @memory[1]
      puts "Second part: #{@prev_sent}"
      STDOUT.flush
    end
    @prev_sent = @memory[1]
    @memory = nil
  end
end

class NIC
  def initialize(routing,id)
    @routing = routing
    @memory = []
    @id = id
    @in_memory = id
  end

  def <<(el)
    @memory << el
    if @memory.size == 3
      debug4 "#{@id} sending a packet #{@memory.join(',')}"
      dest = @memory.shift
      coords = [@memory.shift,@memory.shift]
      @routing.send(@id, dest, coords) 
      @memory.clear
    end
  end


  def pop
    if @in_memory
      y = @in_memory
      @in_memory = nil
      return y
    end
    r = @routing.receive(@id)
    if r
      #puts "#{@id} receiving a packet"
      x,y = r
      @in_memory = y
      return x
    else
      -1
    end
  end

  def empty?
    false
  end
end

routing = Routing.new

threads = []
50.times do |i|
  threads << Thread.new do
     Thread.current.abort_on_exception = true
    nic = NIC.new(routing, i)
    iterate(input_copy, stdin: nic, stdout: nic)
    puts "End of NIC #{i}"
  end
end

threads.each(&:join)
