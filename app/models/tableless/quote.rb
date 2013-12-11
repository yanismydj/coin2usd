class Quote
  attr_accessor :bids, :asks, :price

  def initialize(quantity = 0, type = :buy)
    if type == :buy
      bitstamp_order_book_asks.each do |ask|
        if quantity > ask.quantity
          # aggregate asks since just one order will not fulfil this request
          combined_orders << asks
          #quantity_combined += ask.quantity
        else
          @price = ask.price
          break
        end
      end
    else # they are selling
      bitstamp_order_book_bids.each do |bid|
        if quantity > bid.quantity
          # aggregate bids since just one order will not fulfil this request
        else
          @price = bid.price
          break
        end
      end
    end
  end

  def combined_orders
    @combined_orders ||= []
  end

  def quantity_combined
    @quantity_combined ||= 0
  end

  def lowest_ask # lowest priced offer to sell
    bitstamp_order_book_asks.last # ["873.10", "0.05500000"]
  end

  def highest_bid # offer to buy
    bitstamp_order_book_bids.first # ["0.01", "1044278.00000000"]
  end

  def bitstamp_order_book_bids
    # sorting by price, descending
    @bids ||= bitstamp_order_book_data["bids"].map do |bid|
      Bid.new bid
    end
  end

  def bitstamp_order_book_asks
    # sorting by price, ascending
    @asks ||= bitstamp_order_book_data["asks"].map do |ask|
      Ask.new ask
    end
  end

  def bitstamp_order_book_data
    response = HTTParty.get bitstamp_order_book_url
    response.parsed_response
  end

  def bitstamp_order_book_url
    'https://www.bitstamp.net/api/order_book/'
  end
end