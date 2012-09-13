#!/usr/bin/ruby

class GooglerCommitee
  def initialize(n, s, p, *total_points)
    @n, @s, @p = n, s, p
    @total_points = total_points
  end

  def get_max_result
    return @total_points.size if @p == 0
    return @total_points.count { |tp| tp > 0 } if @p == 1

    @result = 0
    @total_points.each do |tp|
      if tp >= @p + (@p - 1) + (@p - 1)
        @result += 1
      elsif @s > 0 && (tp >= @p + (@p - 2) + (@p - 2))
        @result += 1
        @s -= 1
      end
    end
    @result
  end
end

contents = File.readlines(ARGV[0])
contents.delete_at(0)

File.open('output.txt', 'w') do |f|
  contents.each_with_index do |input_line, index|
    input = input_line.split.map { |nr| nr.to_i }
    f.puts "Case ##{index + 1}: #{GooglerCommitee.new(*input).get_max_result}"
  end
end
