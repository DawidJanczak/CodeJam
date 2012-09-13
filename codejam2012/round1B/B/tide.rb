#!/usr/bin/ruby

class Tide
  def initialize(h, n, m, ceilings, floors)
    @h, @n, @m = h, n, m
    @ceilings = ceilings
    @floors = floors
    @current = [0, 0]
    @FINISH = @n, @m
    @HEIGHT = 50
    @initial_points = []
  end

  def go_furthest(current)
    if can_go_left
      go_left
    end

  end

  def move
    p can_move_left
    p can_move_up
    p can_move_right
    p can_move_down
  end

  def can_move_left
    return false if @current[1] < 1
    left = [@current[0], @current[1] - 1]
    return false if ceiling(left) - @h < @HEIGHT
    return false if ceiling(left) - floor < @HEIGHT
    return false if ceiling(left) - floor(left) < @HEIGHT
    return false if ceiling - floor(left) < @HEIGHT
    return true
  end
  def can_move_up
    return false if @current[0] < 1
    up = [@current[0] - 1, @current[1]]
    return false if ceiling(up) - @h < @HEIGHT
    return false if ceiling(up) - floor < @HEIGHT
    return false if ceiling(up) - floor(up) < @HEIGHT
    return false if ceiling - floor(up) < @HEIGHT
    return true
  end
  def can_move_right
    return false if @current[1] + 1 >= @m
    right = [@current[0], @current[1] + 1]
    return false if ceiling(right) - @h < @HEIGHT
    return false if ceiling(right) - floor < @HEIGHT
    return false if ceiling(right) - floor(right) < @HEIGHT
    return false if ceiling - floor(right) < @HEIGHT
    return true
  end
  def can_move_down
    return false if @current[0] + 1 >= @n
    down = [@current[0] + 1, @current[1]]
    return false if ceiling(down) - @h < @HEIGHT
    return false if ceiling(down) - floor < @HEIGHT
    return false if ceiling(down) - floor(down) < @HEIGHT
    return false if ceiling - floor(down) < @HEIGHT
    return true
  end

  def move_left
    @current[1] -= 1
  end
  def move_left
    @current[0] -= 1
  end
  def move_left
    @current[1] += 1
  end
  def move_left
    @current[0] += 1
  end

  def ceiling(arr = @current)
    @ceilings[arr[0]][arr[1]]
  end

  def floor(arr = @current)
    @floors[arr[0]][arr[1]]
  end
end


contents = File.readlines(ARGV[0])
nr_of_tcs = contents.shift.to_i

File.open('output.txt', 'w') do |f|
  nr_of_tcs.times do |tc_nr|
    h, n, m = contents.shift.split.map { |el| el.to_i }
    ceilings, floors = [], []
    contents.shift(n).each { |row| ceilings << row.split.map(&:to_i) }
    contents.shift(n).each { |row| floors << row.split.map(&:to_i) }
    t = Tide.new(h, n, m, ceilings, floors)
    p t
    t.move
  end
  #contents.each_with_index do |input_line, index|
    #numbers = input_line.split.map { |nr| nr.to_i }
    #points = numbers.each_slice(2).inject([]) { |points, slice| points << Point.new(*slice) }
    #t = Triangle.new(*points)
    #f.puts "Case ##{index + 1}: #{t}"
  #end
end
