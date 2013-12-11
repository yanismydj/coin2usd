require 'spec_helper'

describe Quote, vcr: { match_requests_on: [:host] } do
  describe "bitstamp_order_book_data" do
    let(:quote) { Quote.new }
    
    it "gets some data" do
      quote.bitstamp_order_book_data.should be_an Hash
    end

    it "is using vcr and replaying a response" do
      quote.bitstamp_order_book_data["timestamp"].should == "1386797143"
    end

    it "has bids" do # we recorded a response with vcr so this will be deterministic
      quote.bitstamp_order_book_data["bids"].size.should == 2622
    end
  end

  describe "bitstamp_order_book_bids" do
    let(:quote) { Quote.new }

    it { quote.bitstamp_order_book_bids.should be_an Array }

    it "has bids" do
      quote.bitstamp_order_book_bids.size.should == 2622
    end
  end

  describe "bitstamp_order_book_asks" do
    let(:quote) { Quote.new }

    it { quote.bitstamp_order_book_asks.should be_an Array }

    it "has bids" do
      quote.bitstamp_order_book_asks.size.should == 1787
    end
  end

  describe "highest_ask" do
    let(:quote) { Quote.new }
    it { quote.highest_ask.should == ["873.10", "0.05500000"] }
  end

  describe "lowest_bid" do
    let(:quote) { Quote.new }
    it { quote.lowest_bid.should == ["0.01", "1044278.00000000"] }
  end
end