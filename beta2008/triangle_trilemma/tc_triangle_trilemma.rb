require_relative 'triangle_trilemma.rb'
require 'test/unit'

class TestTriangle < Test::Unit::TestCase
  def setup
    p1 = Point.new(0, 0)
    p2 = Point.new(0, 4)
    p3 = Point.new(1, 2)
    @first = Triangle.new(p1, p2, p3)

    p4 = Point.new(1, 1)
    p5 = Point.new(1, 4)
    p6 = Point.new(3, 2)
    @second = Triangle.new(p4, p5, p6)

    p7 = Point.new(2, 2)
    p8 = Point.new(2, 4)
    p9 = Point.new(4, 3)
    @third = Triangle.new(p7, p8, p9)

    p10 = Point.new(3, 3)
    p11 = Point.new(3, 4)
    p12 = Point.new(5, 3)
    @fourth = Triangle.new(p10, p11, p12)

    p13 = Point.new(4, 4)
    p14 = Point.new(4, 5)
    p15 = Point.new(5, 6)
    @fifth = Triangle.new(p13, p14, p15)

    p16 = Point.new(5, 5)
    p17 = Point.new(5, 6)
    p18 = Point.new(6, 5)
    @sixth = Triangle.new(p16, p17, p18)

    p19 = Point.new(6, 6)
    p20 = Point.new(6, 7)
    p21 = Point.new(6, 8)
    @seventh = Triangle.new(p19, p20, p21)

    p22 = Point.new(7, 7)
    @eighth = Triangle.new(p22, p22, p22)
  end

  def test_is_valid
    assert_equal(true, @first.is_valid?)
    assert_equal(true, @second.is_valid?)
    assert_equal(true, @third.is_valid?)
    assert_equal(true, @fourth.is_valid?)
    assert_equal(true, @fifth.is_valid?)
    assert_equal(true, @sixth.is_valid?)
    assert_equal(false, @seventh.is_valid?)
    assert_equal(false, @eighth.is_valid?)
  end

  def test_lengths
    #assert_equal(:isosceles, @first.lengths_kind)
    #assert_equal(:scalene, @second.lengths_kind)
    #assert_equal(:isosceles, @third.lengths_kind)
    #assert_equal(:scalene, @fourth.lengths_kind)
    #assert_equal(:scalene, @fifth.lengths_kind)
    #assert_equal(:isosceles, @sixth.lengths_kind)
    #assert_nil(@seventh.lengths_kind)
    #assert_nil(@eighth.lengths_kind)
  end

  def test_angles
    #assert_equal(:obtuse, @first.angles_kind)
    #assert_equal(:acute, @second.angles_kind)
    #assert_equal(:acute, @third.angles_kind)
    #assert_equal(:right, @fourth.angles_kind)
    #assert_equal(:obtuse, @fifth.angles_kind)
    #assert_equal(:right, @sixth.angles_kind)
    #assert_nil(@seventh.angles_kind)
    #assert_nil(@eighth.angles_kind)
  end
end
