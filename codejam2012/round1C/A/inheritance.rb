#!/usr/bin/ruby

class Inheritance
  def initialize(classes)
    @classes = classes
    @paths = []
    @diamond = false
  end

  def bfs_start
    @classes.each { |c| bfs(c, c) }
  end

  def bfs(starting_node, node)
    return if @diamond
    if node[1].empty?
      if @paths[starting_node[0]].nil?
        @paths[starting_node[0]] = []
      end
      unless @paths[starting_node[0]].include?(node[0])
        @paths[starting_node[0]] << node[0]
      else
        @diamond = true
      end
    else
      node[1].each { |child_node| bfs(starting_node, @classes.find { |c| c[0] == child_node }) }
    end
  end

  def to_s
    @diamond ? "Yes" : "No"
  end
end


contents = File.readlines(ARGV[0])
nr_of_tcs = contents.shift.to_i

File.open('output.txt', 'w') do |f|
  nr_of_tcs.times do |tc_nr|
    nr_of_classes = contents.shift.to_i
    classes = contents.shift(nr_of_classes).map.with_index do |line, index|
      arr = line.split
      arr.delete_at(0)
      [index] << arr.map { |nr| nr.to_i - 1 }
    end
    i = Inheritance.new(classes)
    i.bfs_start
    f.puts "Case ##{tc_nr + 1}: #{i}"
  end
end
