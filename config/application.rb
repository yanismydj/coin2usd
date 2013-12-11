require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Coin2usd
  class Application < Rails::Application
    config.generators do |g|
      g.test_framework  :rspec, fixture: true, views: false
    end

    config.autoload_paths += Dir[Rails.root.join('app', 'models', '{**}')]
  end
end
