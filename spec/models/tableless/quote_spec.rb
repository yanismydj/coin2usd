require 'spec_helper'

describe Quote, vcr: { match_requests_on: [:host] } do
  describe "Quote functional" do
    describe "result(output)" do
      context "buying" do
        context "a low amount(fulfilled by 1 ask)" do
          it "provides you a quote" do
            @quote = Quote.new(0.01, :buy)
            @quote.price.should == 871.34
          end
        end

        it "a high quantity(need to aggregate asks)" do
          @quote = Quote.new(100.0, :buy)
          @quote.combined_orders.size.should == 34
          @quote.combined_orders.first.should be_an Ask
          @quote.quantity_combined.should > 50.0
          @quote.combined_orders.first.weight.should_not be_nil
          @quote.price.should == 884.16
        end

        it "adds up to 100% weight" do
          @quote = Quote.new(100.0, :buy)
          @quote.total_combined.should == 1.0
        end
      end

      context "selling" do
        context "a low quantity(fulfilled by 1 bid)" do
          it "provides you a quote" do
            @quote = Quote.new(0.01, :sell)
            @quote.price.should == 870.63
          end
        end

        pending "a high quantity(need to aggregate bids)"
      end
    end
  end

  describe "unit tests" do
    describe "bitstamp_order_book_data" do
      let(:quote) { Quote.new }
      
      it "gets some data" do
        quote.bitstamp_order_book_data.should be_an Hash
      end

      it "is using vcr and replaying a response" do
        quote.bitstamp_order_book_data["timestamp"].should == "1386799078"
      end

      it "has bids" do # we recorded a response with vcr so this will be deterministic
        quote.bitstamp_order_book_data["bids"].size.should == 2653
      end
    end

    describe "bitstamp_order_book_bids" do
      let(:quote) { Quote.new }

      it "gives us an array of bids" do
        quote.bitstamp_order_book_bids.should be_an Array
      end

      it "ensures each member is a bid" do
        quote.bitstamp_order_book_bids.first.should be_a Bid
      end

      it "has bids" do
        quote.bitstamp_order_book_bids.size.should == 2653
      end
    end

    describe "bitstamp_order_book_asks" do
      let(:quote) { Quote.new }

      it "gives us an array of asks" do
        quote.bitstamp_order_book_asks.should be_an Array
      end

      it "ensures each is an ask" do
        quote.bitstamp_order_book_asks.first.should be_a Ask
      end

      it "has bids" do
        quote.bitstamp_order_book_asks.size.should == 1791
      end
    end

    describe "lowest_ask" do
      let(:quote) { Quote.new }
      it { quote.lowest_ask.should be_an Ask }
    end

    describe "highest_bid" do
      let(:quote) { Quote.new }
      it { quote.highest_bid.should be_a Bid }
    end
  end
end