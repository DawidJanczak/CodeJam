#!/usr/bin/ruby

require 'facets/array/delete_values'
require 'set'

class PriceCheck
  def initialize(products, guesses)
    @products, @guesses = products, guesses
    #@guesses_zip = @guesses.zip(@products)
    sorted_guesses = @guesses.zip(@products).sort_by { |m| m[0] }
    @guessed_order = sorted_guesses.map { |g| g[1] }
    @results = Set.new
    @result_size = @products.size
    @queue = [[@products.dup, @guessed_order.dup]]
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

  def test
    bfs
    #new_switch(@products.dup, @guessed_order.dup)
    #p @results
    result = @results.to_a.sort.first
    result.sort
    #start_diff = diff(@products, @guessed_order)
    #@products.each do |product|
      #next_products, next_guesses = @products.dup, @guessed_order.dup
      #next_products.delete(product)
      #next_guesses.delete(product)
      #recursive(next_products, next_guesses, start_diff)
    #end
    #@results.sort.first
  end
  
  def diff(products, guesses)
    products.enum_for(:inject, 0).with_index do |(diff, product), index|
      guesses[index] != product ? diff + 1 : diff
    end
  end
  
  #def recursive(products, guesses, previous_diff)
    #diff = diff(products, guesses)
    #if diff == 0
      #@results << (@products.dup - products).sort
    #elsif diff >= previous_diff
      #return
    #else
      #guesses.each_with_index do |guess, index|
        #next_products, next_guesses = products.dup, guesses.dup
        #next_products.delete(guess)
        #next_guesses.delete(guess)
        #recursive(next_products, next_guesses, diff)
      #end
    #end
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

  def bfs
    until @queue.empty?
      #p "dequeuing"
      pair = @queue.shift
      switch_decreasing(*pair)
    end
  end

  def clean_queue(size)
    #p "Size before deleting: #{@queue.size}"
    @queue.delete_if { |el| el.first.size < size }
    #@queue.each { |el| p el }
    #p "Size after deleting: #{@queue.size}"
  end


  # Returns an array containing pairs with switched order (second elem should be before first)
  def get_decreasing(products, guesses)
    result = Set.new
    guesses[0..-1].each_cons(2) do |con|
      #p "Indexes of #{con} in products: #{products.index(con[0])}, #{products.index(con[0])}" 
      result << con[0] << con[1] if products.index(con[0]) > products.index(con[1])
    end
    result.to_a.flatten
  end

  def switch_decreasing(products, guesses)
    #p "First s_d with #{products} and #{guesses}"
    return if (@products.size - products.size) >= @result_size

    if products == guesses
      new_result = @products.dup - products
      @results_size = new_result.size
      clean_queue(products.size) if @results.empty?
      @results << new_result
    elsif @results.empty?
      decreasing_values = get_decreasing(products, guesses)
      #p "Decreasing_values = #{decreasing_values}"
      if decreasing_values.empty?
        products.each_with_index do |product, counter|
          products_copy, guesses_copy = products.dup, guesses.dup
          products_copy.delete(product)
          guesses_copy.delete(product)
          #p "Queue size is #{@queue.size} and products size is #{products.size}"
          #p "Adding #{products_copy} to queue (decreasing_values)"
          @queue << [products_copy, guesses_copy]
        end
      else
        decreasing_values.each_with_index do |product|
          products_copy, guesses_copy = products.dup, guesses.dup
          products_copy.delete(product)
          guesses_copy.delete(product)
          #p "Queue size is #{@queue.size} and products size is #{products.size}"
          #p "Adding #{products_copy} to queue"
          @queue << [products_copy, guesses_copy]
        end
      end
    end
  end
end
