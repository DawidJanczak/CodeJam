require 'ap'

$DEBUG_PATH = []
$EDGES = 0

raise "Input filename should be given as script argument!" unless ARGV.size > 0

class Transaction
  def initialize
    @cost, @items, @with_perishable = 0, [], false
  end

  attr_reader :cost, :items, :with_perishable

  def add_product(item, price)
    @cost += price
    @items << item
    @with_perishable ||= (item[-1] == ?!)
  end

  def to_s
    "#{@items} costed #{@cost}. Perishable? #{@with_perishable}"
  end
end

class Shop
  def initialize(x, y, products)
    @x, @y = x, y
    @products = products
  end

  attr_reader :x, :y, :items

  def ==(another_shop)
    @x == another_shop.x && @y == another_shop.y
  end

  def buy_items(item_list)
    items_to_buy = items_to_buy(item_list).keys
    transactions = []
    flattened = []

    # Create all combinations of items to buy.
    1.upto(items_to_buy.size) { |i| flattened << items_to_buy.combination(i).to_a }
    flattened.flatten!(1)

    flattened.each do |combination|
      combination_transaction = Transaction.new
      combination.each do |item|
        item_to_add = item_list.include?(item) ? item : perishable(item)
        combination_transaction.add_product(item_to_add, @products[item])
      end
      transactions << combination_transaction
    end

    transactions
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
  @@INIFINITY = 1.0/0

  def initialize(gas_price, items, shops)
    @gas_price, @items, @shops = gas_price, items, shops
    @best_fit = @@INFINITY
  end

  def get_min_cost
    "%.7f" % traverse(0, @@HOME, @shops.dup, @items.dup)
  end

  def traverse(current_cost, current_location, shops_left, items_left, go_home = false)
    return current_cost + cost(current_location) if items_left.empty?
    # When there are no shops left and we still have items, it is a wrong way for sure.
    return @@INIFINITY if shops_left.empty? || current_cost > @best_fit

    traversed = []

    if go_home
      current_cost += cost(current_location)
      current_location = @@HOME
    end

    shops_left.each do |shop|
      transactions = shop.buy_items(items_left)
      next if transactions.empty?

      shops = shops_left - [shop]
      base_cost = current_cost + cost(current_location, shop)

      transactions.each do |transaction|
        items = items_left - transaction.items
        cost = base_cost + transaction.cost
        traversed << traverse(cost, shop, shops, items, transaction.with_perishable)
      end
    end

    @best_fit = traversed.compact.min
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
    f.puts("Case ##{tc_nr + 1}: #{plan.get_min_cost}")
    puts "Case ##{tc_nr + 1}: #{plan.get_min_cost}"
    p "#########################################"
  end
end
ap "Took #{Time.now - beginning} seconds."
