#!/usr/bin/env ruby

class Views
  def initialize(nr_of_peaks, views)
    @nr_of_peaks, @views = nr_of_peaks, views.map { |v| v - 1 }
  end

  def solve
    @heights = Array.new(@nr_of_peaks, 10)
    @views.each.with_index do |view, index|
      diff = view - index
      @heights[view] += diff
      correct_further(view, diff)
      lower = ((index + 1)...view).to_a
      lower.each do |low| 
        @heights[low] -= 1
        return "Impossible" unless check(low)
      end
      puts "Heights: #@heights"
    end
    @heights.join(" ")
  end

  def correct_further(view, diff)
    ((view + 1)..(@heights.size - 1)).each { |further| @heights[further] += diff if @heights[further] }
  end
  
  def check(index)
    (0...index).to_a.each { |prev| return false if @views[index] > @views[prev] && @views[prev] != index }
    true
  end
end

contents = File.readlines(ARGV[0])
nr_of_tcs = contents.delete_at(0).to_i

File.open('output.txt', 'w') do |f|
  nr_of_tcs.times do |tc_nr|
    nr_of_peaks = contents.shift.to_i
    views = contents.shift.split.map(&:to_i)
    v = Views.new(nr_of_peaks, views)
    p v.solve
    #f.puts "Case ##{tc_nr + 1}: #{v.solve}"
  end
end
