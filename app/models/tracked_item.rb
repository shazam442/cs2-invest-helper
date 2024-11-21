class TrackedItem < ApplicationRecord
  # validates string not empty for item_name
  validates :item_name, presence: true, allow_blank: false
  validates :price_data, presence: true, allow_blank: false

  def update_price_data
    response = HTTParty.get(steam_market_price_overview_url)
    self.price_data = response.body

    save
  end

  def steam_market_price_overview_url
    URI::Parser.new.escape(BASE_STEAM_API_URL + item_name)
  end

  def steam_market_url # parse url
    URI::Parser.new.escape("https://steamcommunity.com/market/listings/730/#{item_name}")
  end

  private

  BASE_STEAM_API_URL = "https://steamcommunity.com/market/priceoverview/?country=DE&currency=3&appid=730&market_hash_name=".freeze
end
