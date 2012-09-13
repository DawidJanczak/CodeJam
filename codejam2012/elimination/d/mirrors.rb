#!/usr/bin/ruby

require 'bigdecimal'

class Room
  def initialize(lines)
    @north, @south, @east, @west = *Array.new(4, BigDecimal.new("0.5"))
    found = false
    lines[1...-1].each_with_index do |line|
      line.chomp!
      location = line.index("X")
      if !location.nil?
        @west += location - 1
        @east += line.length - location - 2
        found = true
      elsif !found
        @north += 1
      else
        @south += 1
      end
    end

    def solve(length)
      p "solving with length #{length}"
      #(0...360).each do |degree|
        #p "Hits back at #{degree}" if hits_back?(degree, length)
      #end
      # parallelogram area
      a = [0, 0]
      c = [@east, @south - @north]
      diagonal1_length = Math::hypot(c[0] - a[0], c[1] - a[1])
      diagonal1_half = [(c[0] - a[0]) / 2, (c[1] - a[1]) / 2]
      p diagonal1_half.map { |a| a.to_f }
      p diagonal1_length
    end

    def hits_back?(degree, length)
      nesw = lambda { |dir| length >= 2 * dir }
      corner = lambda { |dir1, dir2| length >= (dir1 ** 2 + dir2 ** 2).sqrt(5) }
      return nesw.call(@north) if degree == 0
      return nesw.call(@east) if degree == 90
      return nesw.call(@south) if degree == 180
      return nesw.call(@west) if degree == 270

      return corner.call(@north, @east) if degree == 45
      return corner.call(@east, @south) if degree == 135
      return corner.call(@south, @west) if degree == 225
      return corner.call(@west, @north) if degree == 315

      if (1...45).include?(degree)
        alfa = 90 - degree
        reflection_degree = degree * 2
        p "Reflection degree for #{degree} is #{reflection_degree}"
      end

    end

  end

  attr_reader :north, :south, :east, :west
end

class Mirror
  def initialize(w, h, d, lines)
    @w, @h, @d = w, h, d
    @room = Room.new(lines)
    @room.solve(@d)
  end
end

contents = File.readlines(ARGV[0])
t = contents.shift.to_i

File.open('output.txt', 'w') do |f|
  tc_index = 1
  t.times do |tc_nr|
    numbers = contents.shift.split.map { |nr| nr.to_i }
    mirror = Mirror.new(*numbers, contents.shift(numbers[0]))
    #room = Room.new(contents.shift(numbers[0]))
    #f.puts "Case ##{index + 1}: #{t}"
  end
end
