# This class represents transaction made in a shop. Transaction is characterized by overall cost,
# list of items bought and a flag denoting whether a perishable item has been purchased.
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
