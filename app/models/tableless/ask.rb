class Ask < Order
  attr_accessor :price, :quantity, :weight

  def initialize(bitstamp_array)
    # bitstamp_arry looks like this ["877.00", "1.74793488"]
    @price = bitstamp_array[0].to_f
    @quantity = bitstamp_array[1].to_f
  end
end