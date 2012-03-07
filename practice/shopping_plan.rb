#!/usr/bin/ruby
#
#TODO Sorting shops according to distance too...?

raise "Input filename should be given as script argument!" unless ARGV.size > 0

# This class represents transaction made in a shop. Transaction is characterized by overall cost,
# list of items bought and a flag denoting whether a perishable item has been purchased.
# TODO This class is also responsible for perishable items clarification. It should not be so.
class Transaction
  include Comparable

  def initialize
    @cost, @items, @with_perishable = 0, [], false
  end

  attr_reader :cost, :items, :with_perishable

  # Transactions may be compared according to their overall cost.
  def <=>(another_transaction)
    @cost <=> another_transaction.cost
  end

  # Product consists of its name and price. Price is added to overall cost and item is added to
  # item list. Additional check whether a perishable item has been bought is made.
  def add_product(item, price)
    @cost += price
    @items << item
    @with_perishable ||= (item[-1] == ?!)
  end

  def to_s
    "#{@items} costed #{@cost}. The transaction " <<
    (@with_perishable ? "included" : "did not include") << " perishable item(s)."
  end
end

# Shop represents a single shop characterized by its coordinates and a list of products it offers.
class Shop
  include Comparable

  def initialize(x, y, products)
    @x, @y = x, y
    @products = products
  end

  attr_reader :x, :y, :products
  protected :products

  # Shops can be compared based on their common products prices. The shop which common items
  # overall price is cheaper than the other is to be considered cheaper.
  def <=>(another_shop)
    common_items = @products.keys & another_shop.products.keys
    common_items.inject(0) { |diff, item| diff += (@products[item] - another_shop.products[item]) } <=> 0
  end

  def buy_items(item_list, all_items = false)
    items = items_to_buy(item_list).keys

    # Create all combinations of items to buy.
    combinations = []
    unless all_items
      combinations = (1..items.size).flat_map { |i| items.combination(i).to_a }
    else
      combinations = items.combination(items.size).to_a
    end

    combinations.map do |combination|
      combination_transaction = Transaction.new
      combination.each do |item|
        item_to_add = item_list.include?(item) ? item : perishable(item)
        combination_transaction.add_product(item_to_add, @products[item])
      end
      combination_transaction
    end.sort
  end

  def to_s
    "[#{x}, #{y}]"
  end

  private

  def perishable(item)
    item.to_s.concat(?!).intern
  end

  def items_to_buy(item_list)
    @products.select do |product, price|
      item_list.include?(product) || item_list.include?(perishable(product))
    end
  end
end

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

  def traverse(current_cost, current_location, shops, items_left, go_home = false)
    # Return cost of this branch if no items are left.
    return current_cost + cost(current_location) if items_left.empty?
    # When there are no shops left and we still have items, it is a wrong way for sure.
    # The method should also be stopped if, at any point, calculated cost is greater than best fit.
    return @@INFINITY if shops.empty? || current_cost > @best_fit

    if go_home
      current_cost += cost(current_location)
      current_location = @@HOME
    end

    shops.sort!
    shops.each do |shop|
      #p "At home with best_fit = #{@best_fit}" if current_location.x == @@HOME.x && current_location.y == @@HOME.y && !go_home
      transactions = shop.buy_items(items_left, shops.size == 1)

      shops_left = shops - [shop]
      travel_cost = current_cost + cost(current_location, shop)

      transactions.each do |transaction|
        shopping_cost = travel_cost + transaction.cost
        items_to_buy = items_left - transaction.items

        unless shopping_cost > @best_fit
          total_cost = traverse(shopping_cost, shop, shops_left, items_to_buy, transaction.with_perishable)
          #p "Found new best_fit = #{@best_fit}" if total_cost < @best_fit
          @best_fit = total_cost if total_cost < @best_fit
        end
      end unless travel_cost > @best_fit
    end

    @best_fit
  end

  def cost(first, second = @@HOME)
    Math.sqrt((second.x - first.x) ** 2 + (second.y - first.y) ** 2) * @gas_price
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
    shops = contents.shift(nr_of_shops).collect do |shop_line|
      shop_data = shop_line.split
      x, y = shop_data.shift(2).map { |num| num.to_i }
      Shop.new(x, y, eval(?{ << shop_data.join(",") << ?}))
    end
    plan = ShoppingPlan.new(gas_price, items, shops)
    t1 = Time.now
    cost = plan.get_min_cost
    f.puts("Case ##{tc_nr + 1}: #{cost}")
    puts "Case ##{tc_nr + 1}: #{cost}"
    p "Took #{Time.now - t1} just to calculate this..."
    p "#########################################"
  end
end
p "Took #{Time.now - beginning} seconds."
