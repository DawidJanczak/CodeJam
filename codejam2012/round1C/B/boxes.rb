#!/usr/bin/ruby

class Factory
  def initialize(toys, boxes)
    @toys = toys
    @boxes = boxes
    @shipped = 0
  end

  def ship_toys
    ship_recursive(0, copy(@toys), copy(@boxes))
  end

  def ship_recursive(nr_of_toys, toys, boxes)
    if toys.empty? || boxes.empty?
      @shipped = [@shipped, nr_of_toys].max
      return
    end

    if toys[0][0] == boxes[0][0]
      to_ship = [toys[0][1], boxes[0][1]].min
      nr_of_toys += to_ship
      remove_toys(toys, to_ship)
      remove_boxes(boxes, to_ship)

      ship_recursive(nr_of_toys, copy(toys), copy(boxes))
    else
      ship_recursive(nr_of_toys, copy(toys), remove_boxes(copy(boxes), boxes[0][1]))
      ship_recursive(nr_of_toys, remove_toys(copy(toys), toys[0][1]), copy(boxes))
    end
  end

  def remove_toys(toys, nr)
    toys[0][1] -= nr
    toys.delete_at(0) if toys[0][1] <= 0
    toys
  end

  def remove_boxes(boxes, nr)
    boxes[0][1] -= nr
    boxes.delete_at(0) if boxes[0][1] <= 0
    boxes
  end

  def to_s
    "#@shipped"
  end

  def copy(arr)
    out = []
    arr.each { |el| out << el.dup }
    out
  end
end

contents = File.readlines(ARGV[0])
nr_of_tcs = contents.shift.to_i

File.open('output.txt', 'w') do |f|
  nr_of_tcs.times do |tc_nr|
    contents.shift
    toys, boxes = [], []
    contents.shift.split.map(&:to_i).each_slice(2) { |arr| toys << [arr[1], arr[0]]}
    contents.shift.split.map(&:to_i).each_slice(2) { |arr| boxes << [arr[1], arr[0]]}
    factory = Factory.new(toys, boxes)
    factory.ship_toys
    f.puts "Case ##{tc_nr + 1}: #{factory}"
    p "Finished TC #{tc_nr + 1}"
  end
end
