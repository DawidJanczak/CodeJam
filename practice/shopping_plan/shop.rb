require_relative 'transaction.rb'

# Shop represents a single shop characterized by its coordinates and a list of products it offers.
class Shop
  def initialize(x, y, products)
    @x, @y = x, y
    @products = products
  end

  attr_reader :x, :y

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
        combination_transaction.add_product(item, @products[item])
      end
      combination_transaction
    end.sort
  end

  def to_s
    "[#{x}, #{y}]"
  end

  private

  def items_to_buy(item_list)
    @products.select do |product, price|
      item_list.include?(product)
    end
  end
end

