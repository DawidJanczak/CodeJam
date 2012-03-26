class Point < Struct.new(:x, :y)
  def -(another_point)
    Math::hypot(x - another_point.x, y - another_point.y)
  end
end

class Triangle < Struct.new(:p1, :p2, :p3)
end

module TriangleTrilemma

end
