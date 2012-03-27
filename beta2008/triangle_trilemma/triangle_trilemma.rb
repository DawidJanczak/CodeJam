class Point < Struct.new(:x, :y)
  def -(another_point)
    Math::hypot(x - another_point.x, y - another_point.y)
  end
end

class Triangle
  @@PYTHAGOREAN_DIFFERENCE = { -1 => :obtuse, 0 => :right, 1 => :acute }

  def initialize(p1, p2, p3)
    @p1, @p2, @p3 = p1, p2, p3
    @distances = [@p1 - @p2, @p1 - @p3, @p2 - @p3].sort
  end

  #Triangle is valid when three points do not lay in one line.
  #This can be checked by simple equation, however division
  #by 0 needs to be taken into account.
  def is_valid?
    p1_p2_denom = @p2.x - @p1.x
    p1_p3_denom = @p3.x - @p1.x

    return false if p1_p2_denom == 0 && p1_p3_denom == 0
    return true if p1_p2_denom == 0 || p1_p3_denom == 0

    first_to_second = (@p2.y - @p1.y) / (p1_p2_denom)
    first_to_third = (@p3.y - @p1.y) / (p1_p3_denom)
    first_to_second != first_to_third
  end

  # Angles kind can be calculated based in Pythagorean Theorem.
  # Type of the triangle is dependant on the equality of the
  # two sides of the equation.
  def angles_kind
    return nil unless is_valid?
    left_side = (@distances[0] ** 2 + @distances[1] ** 2).round(10)
    right_side = (@distances[2] ** 2).round(10)
    @@PYTHAGOREAN_DIFFERENCE[left_side <=> right_side]
  end

  # Having all distances all that needs to be done is checking
  # whether there are any duplicate lengths to determine if
  # the triangle is isosceles or scalene.
  def lengths_kind
    return nil unless is_valid?
    @distances.length != @distances.uniq.length ? :isosceles : :scalene
  end

  def to_s
    if is_valid?
      "#{lengths_kind} #{angles_kind} triangle"
    else
      "not a triangle"
    end
  end
end

contents = File.readlines(ARGV[0])
contents.delete_at(0)

File.open('output.txt', 'w') do |f|
  contents.each_with_index do |input_line, index|
    numbers = input_line.split.map { |nr| nr.to_i }
    points = numbers.each_slice(2).inject([]) { |points, slice| points << Point.new(*slice) }
    f.puts "Case ##{index + 1}: #{Triangle.new(*points)}"
  end
end
