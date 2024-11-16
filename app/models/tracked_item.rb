class TrackedItem < ApplicationRecord
  private

  BASE_STEAM_API_URL = "https://steamcommunity.com/market/priceoverview/?country=DE&currency=3&appid=730&market_hash_name=".freeze

  def update_price_data
    response = HTTParty.get(BASE_STEAM_API_URL + item_name)
    byebug
    self.price_data = response.body
    save
  end
end
