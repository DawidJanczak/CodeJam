require_relative 'transaction.rb'

# Shop represents a single shop characterized by its coordinates and a list of products it offers.
class Shop
  def initialize(x, y, products)
    @x, @y = x, y
    @products = products
  end

  attr_reader :x, :y

  def ==(shop)
    self.x == shop.x && self.y == shop.y
  end

  def buy_items(item_list, all_items = false)
    products = @products.select { |product| item_list.include?(product.name) }

    # Create all combinations of items to buy.
    combinations = []
    unless all_items
      combinations = (1..products.size).flat_map { |i| products.combination(i).to_a }
    else
      combinations = products.combination(products.size).to_a
    end

    # Map item combinations to transaction combinations and sort them.
    combinations.map! { |combination| Transaction.new(combination) }
    combinations.sort!
  end

  def to_s
    "[#{x}, #{y}]"
  end
end

