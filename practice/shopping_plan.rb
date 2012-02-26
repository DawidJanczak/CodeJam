require 'ap'

raise "Input filename should be given as script argument!" unless ARGV.size > 0

class Shop
  def initialize(x, y, items)
    @x, @y = x, y
    @items = items
  end

  attr_reader :x, :y, :items

  #def has_item?(item)
    #@items.has_key?(item)
  #end

  def ==(another_shop)
    @x == another_shop.x && @y == another_shop.y
  end

  #def items_cost(item_list)
    #items_to_buy(item_list).values.inject(:+)
  #end

  #def has_items(item_list)
    #items_to_buy(item_list).keys
  #end

  #def has_perishable_item(item_list)
    #!(item_list - items_to_buy(item_list)).empty?
  #end

  def buy_items(item_list)
    result = [0, [], false]

    @items.each do |item, price|
      perishable = item.to_s.concat(?!).intern
      has_perishable = item_list.include?(perishable)
      if item_list.include?(item) || has_perishable
        result[0] += price
        if has_perishable
          result[1] << perishable
          result[2] = true
        else
          result[1] << item
        end
      end
    end

    result
  end

  def to_s
    "[#{x}, #{y}]"
  end

  private

  def items_to_buy(item_list)
    @items.select do |item, price|
      item_list.include?(item) || item_list.include?(item.to_s.concat(?!).intern)
    end
  end
end

class ShoppingPlan
  @@HOME = Shop.new(0, 0, {})

  def initialize(gas_price, items, shops)
    @gas_price, @items, @shops = gas_price, items, shops
    #@items_left = @items.dup
    #@shops_left = @shops.dup
    p traverse(0, @@HOME, @shops.dup, @items.dup)
  end

  def get_min_cost
    "%.7f" % traverse(0, @@HOME, @shops.dup, @items.dup)
  end

  #def each_shop_having(item)
    #@shops.each { |shop| yield shop if shop.has_item?(item) }
  #end

  #def cheapest_shop(current_location = @@HOME)
    #costs = @shops.map do |shop|
      #next if shop == current_location

      #cost(current_location, shop) + shop.items_cost(@items_left)
    #end

    #ap costs
  #end

  def traverse(current_cost, current_location, shops_left, items_left, go_home = false)
    ap "Current cost is #{current_cost}"
    ap "Current location is #{current_location}"
    ap "Shops left are #{shops_left}"
    ap "Items left are #{items_left}"
    ap "should go home? #{go_home}"
    ap "Total cost when no items left: #{current_cost + cost(current_location)}" if items_left.empty?
    #TODO what when shops_left is empty?
    return current_cost + cost(current_location) if items_left.empty?

    traversed = []

    if go_home
      cost = current_cost + cost(current_location, @@HOME)
      traversed << (current_cost + traverse(cost, @@HOME, shops_left.dup, items_left.dup))
    end
    shops_left.each do |shop|
      ap "Going to shop #{shop}"
      transaction = shop.buy_items(items_left)
      next if transaction[0] == 0
      shops = shops_left - [shop]
      items = items_left - transaction[1]
      #p "Cost is #{cost(current_location, shop)}"
      cost = current_cost + transaction[0] + cost(current_location, shop)
      p "Before calling traverse"
      ap "--------------------------------------------------------"
      traversed << traverse(cost, shop, shops, items)
      p "After calling traverse"
      p "Traversed: #{traversed}"
    end

    p "Traversed: #{traversed}"
    traversed.min
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
    shops = contents.shift(nr_of_shops).collect do |shop_line|
      shop_data = shop_line.split
      x, y = shop_data.shift(2).map { |num| num.to_i }
      Shop.new(x, y, eval(?{ << shop_data.join(",") << ?}))
    end
    plan = ShoppingPlan.new(gas_price, items, shops)
    f.puts("Case ##{tc_nr + 1}: #{plan.get_min_cost}")
    p "#########################################"
    p "#########################################"
    p "#########################################"
  end
end
