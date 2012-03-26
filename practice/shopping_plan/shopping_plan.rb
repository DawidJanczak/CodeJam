#!/usr/bin/ruby

require 'set'
require_relative 'shop.rb'

raise "Input filename should be given as script argument!" unless ARGV.size > 0

class ShoppingPlan
  @@HOME = Shop.new(0, 0, {})
  @@INFINITY = 1.0/0

  def initialize(gas_price, items, shops)
    @gas_price, @items, @shops = gas_price, items, shops
    @best_fit = @@INFINITY
    @sets = {}
  end

  def get_min_cost
    traverse(0, @@HOME, @shops, @items, Set.new)
    "%.7f" % @best_fit
  end

  def path_checked?(shops_visited, next_shop)
    !(@sets.empty? || @sets[shops_visited].nil?)
  end

  def get_cheapest_cost(shops_visited, next_shop)
    @sets[[shops_visited]][next_shop]
  end

  def add_cost(shops_visited, next_shop, cost)
    return if shops_visited.empty?
    #TODO add only when new price is lower than existing
    @sets[shops_visited] = { next_shop => cost }
  end

  def traverse(current_cost, current_location, shops, items, shops_visited, go_home = false)
    # Return cost of this branch if no items are left.
    #p shops_visited
    return current_cost + cost(current_location, @@HOME) if items.empty?
    # When there are no shops left and we still have items, it is a wrong way for sure.
    # The method should also be stopped if, at any point, calculated cost is greater than best fit.
    #return @@INFINITY if shops.empty? || current_cost > @best_fit
    return @@INFINITY if shops.empty?

    #p "Already have #{shops_visited.inspect}" if @sets.include?(shops_visited)

    shops.each do |shop|
      if path_checked?(shops_visited, shop)
        total_cost = current_cost + cost(current_location, shop, go_home)
        @best_fit = total_cost if total_cost < @best_fit
        next
      end

      #p "At home with best_fit = #{@best_fit}" if current_location.x == @@HOME.x && current_location.y == @@HOME.y && !go_home
      transactions = shop.buy_items(items, shops.size == 1)

      shops_left = shops - [shop]
      travel_cost = current_cost + cost(current_location, shop, go_home)

      transactions.each do |transaction|
        shopping_cost = travel_cost + transaction.cost
        #unless shopping_cost > @best_fit
          items_to_buy = items - transaction.bought_items
          #@sets << shops_visited
          total_cost = traverse(shopping_cost, shop, shops_left, items_to_buy, shops_visited.dup.add(shop), transaction.with_perishable)
          add_cost(shops_visited, shop, transaction.cost)
          #TODO sets should be updated here with bigger trees too
          #p "Found new best_fit = #{@best_fit}" if total_cost < @best_fit
          @best_fit = total_cost if total_cost < @best_fit
        #end
      end# unless travel_cost > @best_fit
    end

    @best_fit
  end

  private

  def distance(first, second)
    Math.sqrt((second.x - first.x) ** 2 + (second.y - first.y) ** 2)
  end

  def cost(first, second, via_home = false)
    if via_home
      distance(first, @@HOME) + distance(@@HOME, second)
    else
      distance(first, second)
    end * @gas_price
  end
end

def get_shops(item_list, shop_lines)
  perishable_items = item_list.select { |item| item[-1] == ?! }
  perishable_items.map! { |item| item[0...-1] }

  shop_lines.collect do |shop_line|
    shop_data = shop_line.split
    x, y = shop_data.shift(2).map { |num| num.to_i }
    products = shop_data.map do |shop_item|
      item, price = shop_item.split(?:)
      item << ?! if perishable_items.include?(item)
      Product.new(item.intern, price.to_i)
    end
    Shop.new(x, y, products)
  end
end

contents = File.readlines(ARGV[0])
num_of_testcases = contents.shift.to_i
beginning = Time.now
File.open('output.txt', 'w') do |f|
  num_of_testcases.times do |tc_nr|
    nr_of_shops, gas_price = contents.shift.split[1..-1].map { |el| el.to_i }
    items = contents.shift.split.map { |item| item.intern }
    p "TC NR #{tc_nr}"
    plan = ShoppingPlan.new(gas_price, items, get_shops(items, contents.shift(nr_of_shops)))
    t1 = Time.now
    cost = plan.get_min_cost
    f.puts("Case ##{tc_nr + 1}: #{cost}")
    puts "Case ##{tc_nr + 1}: #{cost}"
    p "Took #{Time.now - t1} just to calculate this..."
    p "#########################################"
  end
end
p "Took #{Time.now - beginning} seconds."
