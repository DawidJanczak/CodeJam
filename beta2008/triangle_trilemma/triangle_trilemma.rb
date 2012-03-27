class Point < Struct.new(:x, :y)
  def -(another_point)
    Math::hypot(x - another_point.x, y - another_point.y)
  end
end

class Triangle < Struct.new(:p1, :p2, :p3)
  def is_valid?
    p1_p2_denom = p2.x - p1.x
    p1_p3_denom = p3.x - p1.x

    return false if p1_p2_denom == 0 && p1_p3_denom == 0
    return true if p1_p2_denom == 0 || p1_p3_denom == 0

    first_to_second = (p2.y - p1.y) / (p1_p2_denom)
    first_to_third = (p3.y - p1.y) / (p1_p3_denom)
    first_to_second != first_to_third
  end
end

