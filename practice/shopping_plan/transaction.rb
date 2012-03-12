require_relative('product.rb')
# This class represents transaction made in a shop. Transaction is characterized by overall cost,
# list of items bought and a flag denoting whether a perishable item has been purchased.
class Transaction
  include Comparable

  def initialize(products)
    @cost, @bought_items, @with_perishable = 0, [], false
    products.each do |product|
      @cost += product.price
      @bought_items << product.name
      @with_perishable ||= product.perishable?
    end
  end

  attr_reader :cost, :bought_items, :with_perishable

  # Transactions may be compared according to their overall cost.
  def <=>(another_transaction)
    @cost <=> another_transaction.cost
  end

  def to_s
    "#{@bought_items} costed #{cost}. The transaction " <<
    (@with_perishable ? "included" : "did not include") << " perishable item(s)."
  end
end
