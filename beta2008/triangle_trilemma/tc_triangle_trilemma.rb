#!/usr/bin/ruby

require_relative 'triangle.rb'
require 'test/unit'

class TestTriangle < Test::Unit::TestCase
  def setup
    points = [
      [0, 0], [0, 4], [1, 2],
      [1, 1], [1, 4], [3, 2],
      [2, 2], [2, 4], [4, 3],
      [3, 3], [3, 4], [5, 3],
      [4, 4], [4, 5], [5, 6],
      [5, 5], [5, 6], [6, 5],
      [6, 6], [6, 7], [6, 8],
      [7, 7], [7, 7], [7, 7],
    ].map { |point| Point.new(*point) }

    @triangles = points.each_slice(3).inject([]) do |triangles, chunk|
      triangles << Triangle.new(*chunk)
    end
  end

  def test_is_valid
    assertion_values = Array.new(6, true) << false << false
    helper_tester(assertion_values, :is_valid?)
  end

  def test_lengths
    assertion_values = [:isosceles, :scalene, :isosceles, :scalene, :scalene, :isosceles, nil, nil]
    helper_tester(assertion_values, :lengths_kind)
  end

  def test_angles
    assertion_values = [:obtuse, :acute, :acute, :right, :obtuse, :right, nil, nil]
    helper_tester(assertion_values, :angles_kind)
  end
  
  def helper_tester(assertion_values, method_name)
    assertion_values.zip(@triangles) do |assertion|
      assert_equal(assertion[0], assertion[1].send(method_name))
    end
  end
end
