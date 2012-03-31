require 'matrix'

class Point < Struct.new(:x, :y)
  def -(another_point)
    Math::hypot(x - another_point.x, y - another_point.y)
  end
end

class Triangle
  # This hash is common to all Triangle objects so it is stored as class instance variable.
  @PYTHAGOREAN_DIFFERENCE = { -1 => :obtuse, 0 => :right, 1 => :acute }

  # Reader for class instance variable.
  class << self
    attr_reader :PYTHAGOREAN_DIFFERENCE
  end

  # Initialization is done with three points.
  # After that validity is checked.
  # If a triangle is valid, the distances between points are calculated and sorted.
  def initialize(p1, p2, p3)
    @p1, @p2, @p3 = p1, p2, p3
    @is_valid = check_validity
    @distances = [@p1 - @p2, @p1 - @p3, @p2 - @p3].sort if is_valid?
  end

  attr_reader :is_valid
  alias_method :is_valid?, :is_valid

  #Area can be calculated as a halved absolute value of matrix determinant.
  def area
    matrix = Matrix[[@p2.x - @p1.x, @p2.y - @p1.y], [@p3.x - @p1.x, @p3.y - @p1.y]]
    (0.5 * matrix.det).abs
  end

  # Angles kind can be calculated based in Pythagorean Theorem.
  # Type of the triangle is dependant on the equality of the
  # two sides of the equation.
  def angles_kind
    return nil unless is_valid?
    left_side = (@distances[0] ** 2 + @distances[1] ** 2).round
    right_side = (@distances[2] ** 2).round
    self.class.PYTHAGOREAN_DIFFERENCE[left_side <=> right_side]
  end

  # Having all distances all that needs to be done is checking
  # whether there are any duplicate lengths to determine if
  # the triangle is isosceles or scalene.
  def lengths_kind
    return nil unless is_valid?
    @distances.length != @distances.uniq.length ? :isosceles : :scalene
  end

  # String representations are used for output and specified by CodeJam.
  def to_s
    if is_valid?
      "#{lengths_kind} #{angles_kind} triangle"
    else
      "not a triangle"
    end
  end

  private

  #Triangle is invalid if any two of the three points are the same points.
  #Apart from that triangle is invalid if its area is equal to 0.
  def check_validity
    return false if @p1 == @p2 || @p1 == @p3 || @p2 == @p3
    area > 0
  end
end

