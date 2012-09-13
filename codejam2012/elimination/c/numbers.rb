#!/usr/bin/ruby

class CheckNumbers
  def initialize(a, b)
    @a, @b = a, b
  end

  def solve
    return 0 if @a < 10
    result = 0

    (@a..@b).each do |nr|
      stringed = nr.to_s
      stringed_length = stringed.length
      tmp = []
      (stringed_length - 1).times do
        stringed.insert(0, stringed.slice!(-1))
        stringed_int = stringed.to_i
        if (@a..@b).cover?(stringed_int) && stringed_int > nr && !tmp.include?(stringed_int)
          result += 1 
          tmp << stringed_int
        end
      end
    end

    result
  end
end

contents = File.readlines(ARGV[0])
contents.delete_at(0)

File.open('output.txt', 'w') do |f|
  contents.each_with_index do |input_line, index|
    numbers = input_line.split.map { |nr| nr.to_i }
    f.puts "Case ##{index + 1}: #{CheckNumbers.new(*numbers).solve}"
    puts "Case ##{index + 1}"
  end
end
