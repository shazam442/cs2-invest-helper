class TrackedItem < ApplicationRecord
  validates :item_name, presence: true, allow_blank: false
  validate :is_hash, if: -> { price_overview_json.present? }

  def update_price_overview_json
    response = HTTParty.get(steam_market_price_overview_url)

    json = JSON.parse(response.body)

    update(
      last_request_success: json["success"],
      last_request_time: Time.now,
      lowest_price: json["lowest_price"],
      median_price: json["median_price"],
      volume_sold: json["volume"]&.gsub(/\D/, ""),
      price_overview_json: json
    )
  end

  def steam_market_price_overview_url
    BASE_STEAM_API_URL + uri_encoded_item_name
  end

  def steam_market_url # parse url
    URI::Parser.new.escape("https://steamcommunity.com/market/listings/730/#{item_name}")
  end

  private

  def is_hash
    return if price_overview_json.is_a?(Hash)

    errors.add(:price_overview_json, :invalid_data_type, message: "must be a hash")
  end

  def uri_encoded_item_name
    URI::Parser.new.escape(item_name).gsub("&", "%26")
  end

  BASE_STEAM_API_URL = "https://steamcommunity.com/market/priceoverview/?country=DE&currency=3&appid=730&market_hash_name=".freeze
end
