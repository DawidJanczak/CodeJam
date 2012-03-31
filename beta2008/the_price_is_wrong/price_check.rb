#!/usr/bin/ruby

require 'facets/array/delete_values'

class PriceCheck
  def initialize(products, guesses)
    @products, @guesses = products, guesses
    #@guesses_zip = @guesses.zip(@products)
    sorted_guesses = @guesses.zip(@products).sort_by { |m| m[0] }
    @guessed_order = sorted_guesses.map { |g| g[1] }
  end

  #def min_switch
    #result = []
    #@guesses_zip.each_cons(2) { |tuple| result << tuple[0][1] << tuple[1][1] if tuple[0][0] > tuple[1][0] }
    #to_remove = []
    #@size = result.size
    #result.each_cons(2) { |t| to_remove = t[0] if t[0] == t[1] }
    #result.delete_values(*to_remove)
    #result
  #end

  def switch
    #switch = min_switch
    #p switch.sort
    #switch.sort.take(@size / 2)
    solutions = []
    1.upto(@products.size) do |min_prod|
      found = false
      @products.combination(min_prod).each do |comb|
        products_copy, guesses_copy = @products.dup, @guessed_order.dup
        products_copy.delete_values(*comb)
        guesses_copy.delete_values(*comb)
        if products_copy == guesses_copy
          found ||= true
          solutions << comb.sort
        end
      end
      return solutions.sort[0] if found
    end
  end
end
