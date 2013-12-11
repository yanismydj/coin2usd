class QuoteController < ApplicationController
  def buy
    @quote = Quote.new params["quantity"].to_f, :buy
    render json: @quote.to_json
  end

  def sell
    @quote = Quote.new params["quantity"].to_f, :sell
    render json: @quote.to_json
  end
end
