class Quote
  attr_accessor :asks, :bids, :price, :quote_quantity, :quantity_combined

  def initialize(quantity = 0.0, type = :buy)
    @quote_quantity = quantity
    @quantity_combined = 0.0
    if type == :buy
      bitstamp_order_book_asks.each do |ask|
        if quantity > ask.quantity
          # aggregate asks since just one order will not fulfil this request
          combined_orders << ask

          if (@quantity_combined + ask.quantity) >= quantity
            calculate_aggregated_price
            break
          else
            @quantity_combined += ask.quantity
          end
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

  def calculate_aggregated_price
    @price = 0.0 
    combined_orders.each_with_index do |order, key|
      if key != combined_orders.size - 1
        order.weight = order.quantity / @quote_quantity
      else
        #last order
        order.weight = (@quote_quantity - @quantity_combined) / @quote_quantity
      end

      @price += order.weighted_price
    end

    @price = @price.round(2)
  end

  def total_combined
    output = 0.0
    combined_orders.each do |order|
      output += order.weight
    end
    output.round
  end

  def combined_orders
    @combined_orders ||= []
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