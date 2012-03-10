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
    "%.7f" % traverse(0, @@HOME, @shops.dup, @items.dup)
  end

  def traverse(current_cost, current_location, shops_left, items_left, go_home = false)
    # Return cost of this branch if no items are left.
    return current_cost + cost(current_location) if items_left.empty?
    # When there are no shops left and we still have items, it is a wrong way for sure.
    # The method should also be stopped if, at any point, calculated cost is greater than best fit.
    return @@INFINITY if shops_left.empty? || current_cost > @best_fit

    traversed = []

    if go_home
      current_cost += cost(current_location)
      current_location = @@HOME
    end

    shops_left.each do |shop|
      transactions = shop.buy_items(items_left, shops_left.size == 1)
      next if transactions.empty?

      shops = shops_left - [shop]
      base_cost = current_cost + cost(current_location, shop)

      transactions.each do |transaction|
        items = items_left - transaction.items
        cost = base_cost + transaction.cost
        traversed << traverse(cost, shop, shops, items, transaction.with_perishable)
      end
    end

    candidate = traversed.compact.min
    @best_fit = candidate unless (candidate.nil? || candidate > @best_fit)
  end

  def cost(first, second = @@HOME)
    Math.sqrt((second.x - first.x) ** 2 + (second.y - first.y) ** 2) * @gas_price
  end
end

def get_shops(item_list, shop_lines)
  shop_lines.collect do |shop_line|
    shop_data = shop_line.split
    x, y = shop_data.shift(2).map { |num| num.to_i }
    shop_data.map! do |shop_item|
      item = (shop_item[0...shop_item.index(?:)] + ?!).intern
      item_list.include?(item) ? shop_item.insert(shop_item.index(?:), ?!) : shop_item
    end
    Shop.new(x, y, eval(?{ << shop_data.join(",") << ?}))
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
