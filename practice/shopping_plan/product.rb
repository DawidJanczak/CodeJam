# Simple class to hold shop product. Product has a name and price.
class Product
  def initialize(name, price)
    @name, @price = name, price
  end

  def perishable?
    @name[-1] == ?!
  end

  attr_reader :name, :price

  def to_s
    "#{name}: #{price}"
  end
end
