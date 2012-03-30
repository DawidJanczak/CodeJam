#!/usr/bin/ruby

require_relative 'triangle.rb'

contents = File.readlines(ARGV[0])
contents.delete_at(0)

File.open('output.txt', 'w') do |f|
  contents.each_with_index do |input_line, index|
    numbers = input_line.split.map { |nr| nr.to_i }
    points = numbers.each_slice(2).inject([]) { |points, slice| points << Point.new(*slice) }
    t = Triangle.new(*points)
    f.puts "Case ##{index + 1}: #{t}"
  end
end
