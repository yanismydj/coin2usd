class Quote
  def highest_ask
    bitstamp_order_book_asks.first # ["873.10", "0.05500000"]
  end

  def lowest_bid
    bitstamp_order_book_bids.last # ["0.01", "1044278.00000000"]
  end

  def bitstamp_order_book_bids
    bitstamp_order_book_data["bids"] # sorting by price, descending
  end

  def bitstamp_order_book_asks
    bitstamp_order_book_data["asks"] # sorting by price, ascending
  end

  def bitstamp_order_book_data
    response = HTTParty.get bitstamp_order_book_url
    response.parsed_response
  end

  def bitstamp_order_book_url
    'https://www.bitstamp.net/api/order_book/'
  end
end