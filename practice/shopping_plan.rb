require 'ap'

$DEBUG_PATH = []
$EDGES = 0

raise "Input filename should be given as script argument!" unless ARGV.size > 0

class Transaction
  def initialize
    @cost, @items, @with_perishable = 0, [], false
  end

  attr_reader :cost, :items, :with_perishable

  def add_item(item, price)
    @cost += price
    @items << item
    @with_perishable = (item[-1] == ?!)
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
        combination_transaction.add_item(item_to_add, @products[item])
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

  def initialize(gas_price, items, shops)
    @gas_price, @items, @shops = gas_price, items, shops
  end

  def get_min_cost
    "%.7f" % traverse(0, @@HOME, @shops.dup, @items.dup)
  end

  def each_shop_having(item)
    @shops.each { |shop| yield shop if shop.has_item?(item) }
  end

  #def cheapest_shop(current_location = @@HOME)
    #costs = @shops.map do |shop|
      #next if shop == current_location

      #cost(current_location, shop) + shop.items_cost(@items_left)
    #end

    #ap costs
  #end

  def cheapest_shop(item)
    each_shop_having(item).min { |s1, s2| s1.get_item_price(item) <=> s2.get_item_price(item) }
  end

  def traverse(current_cost, current_location, shops_left, items_left, go_home = false)
    #ap "Current cost is #{current_cost}"
    #ap "Current location is #{current_location}"
    #ap "Shops left are #{shops_left}"
    #ap "Items left are #{items_left}"
    #ap "should go home? #{go_home}"
    #ap "Total cost when no items left: #{current_cost + cost(current_location)}" if items_left.empty?
    #$DEBUG_PATH << "Entering from #{current_location}, have #{items_left} items left to buy and paid #{current_cost}."
    #$DEBUG_PATH << "Shall I go home? #{go_home}"
    #$DEBUG_PATH << "It seems there are no items left, leaving." if items_left.empty?
    return current_cost + cost(current_location) if items_left.empty?
    # When there are no shops left and we still have items, it is a wrong way for sure.
    #$DEBUG_PATH << "No shops left!" if shops_left.empty?
    return 1.0/0 if shops_left.empty?
    #$EDGES += 1

    traversed = []

    p "No more shops left" if shops_left.empty?

    if go_home
      cost = current_cost + cost(current_location, @@HOME)
      traversed << (current_cost + traverse(cost, @@HOME, shops_left.dup, items_left.dup))
    end
    shops_left.each do |shop|
      #ap "Going to shop #{shop}"
      transactions = shop.buy_items(items_left)
      #ap "Transactions made in shop #{shop}: #{transactions}"
      next if transactions.empty?

      shops = shops_left - [shop]
      base_cost = current_cost + cost(current_location, shop)

      transactions.each do |transaction|
        items = items_left - transaction.items
        cost = base_cost + transaction.cost
        #$DEBUG_PATH << "Transaction #{transaction} in shop #{shop}"
        traversed << traverse(cost, shop, shops, items)
      end

      #next if transaction[0] == 0
      #shops = shops_left - [shop]
      #items = items_left - transaction[1]
      ##p "Cost is #{cost(current_location, shop)}"
      #cost = current_cost + transaction[0] + cost(current_location, shop)
      #p "Before calling traverse"
      #ap "--------------------------------------------------------"
      #traversed << traverse(cost, shop, shops, items)
      #p "After calling traverse"
      #p "Traversed: #{traversed}"
    end

    #p "Traversed: #{traversed}"
    #$DEBUG_PATH << "It seems the best cost for paying from #{current_location} is #{traversed.compact.min}"
    traversed.compact.min
  end

  def cost(first, second = @@HOME)
    Math.sqrt((second.x - first.x) ** 2 + (second.y - first.y) ** 2) * @gas_price
  end
end

contents = File.readlines(ARGV[0])
num_of_testcases = contents.shift.to_i
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
    #ap $DEBUG_PATH
    #p "Nr of edges traversed: #{$EDGES}"
    p "#########################################"
    p "#########################################"
    p "#########################################"
  end
end
