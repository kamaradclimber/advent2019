def debug(message)
  puts message if ENV['DEBUG']
end

def input
  DATA.tap(&:rewind).read.split(',').map(&:to_i)
end
