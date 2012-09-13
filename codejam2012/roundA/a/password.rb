#!/usr/bin/ruby

class Password
  def initialize(a, b, probabilities)
    @a, @b = a, b
    @probabilities = probabilities
  end

  def get_min

  end

  def get_min_keep_typing
    
  end
end

contents = File.readlines(ARGV[0])
t = contents.shift.to_i

File.open('output.txt', 'w') do |f|
  tc_index = 1
  t.times do |tc_nr|
    numbers = contents.shift.each { |el| el.to_i }
    probabilities = contents.shift.each { |el| el.to_f }
    mirror = Mirror.new(*numbers, contents.shift(numbers[0]))
    #room = Room.new(contents.shift(numbers[0]))
    #f.puts "Case ##{index + 1}: #{t}"
  end
end
