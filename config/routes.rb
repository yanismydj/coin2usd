Coin2usd::Application.routes.draw do
  get "quote/buy"
  get "quote/sell"
  
  root 'home#index'
end
