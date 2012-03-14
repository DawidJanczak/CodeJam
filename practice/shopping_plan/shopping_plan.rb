#!/usr/bin/ruby

require_relative 'shop.rb'

raise "Input filename should be given as script argument!" unless ARGV.size > 0

class ShoppingPlan
  @@HOME = Shop.new(0, 0, {})
  @@INFINITY = 1.0/0

  def initialize(gas_price, items, shops)
    @gas_price, @items, @shops = gas_price, items, shops
    @best_fit = @@INFINITY
  end

  def get_min_cost
    traverse(0, @@HOME, @shops, @items)
    "%.7f" % @best_fit
  end

  def traverse(current_cost, current_location, shops, items, go_home = false)
    # Return cost of this branch if no items are left.
    return current_cost + cost(current_location, @@HOME) if items.empty?
    # When there are no shops left and we still have items, it is a wrong way for sure.
    # The method should also be stopped if, at any point, calculated cost is greater than best fit.
    return @@INFINITY if shops.empty? || current_cost > @best_fit

    shops.each do |shop|
      #p "At home with best_fit = #{@best_fit}" if current_location.x == @@HOME.x && current_location.y == @@HOME.y && !go_home
      transactions = shop.buy_items(items, shops.size == 1)

      shops_left = shops - [shop]
      travel_cost = current_cost + cost(current_location, shop, go_home)

      transactions.each do |transaction|
        shopping_cost = travel_cost + transaction.cost
        unless shopping_cost > @best_fit
          items_to_buy = items - transaction.bought_items
          total_cost = traverse(shopping_cost, shop, shops_left, items_to_buy, transaction.with_perishable)
          #p "Found new best_fit = #{@best_fit}" if total_cost < @best_fit
          @best_fit = total_cost if total_cost < @best_fit
        end
      end unless travel_cost > @best_fit
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
