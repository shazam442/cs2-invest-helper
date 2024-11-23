class SteamMarketPriceOverview < ApplicationRecord
  belongs_to :tracked_item

  def url
    BASE_STEAM_API_URL + tracked_item.uri_encoded_market_hash_name
  end

  def update
    response = HTTParty.get(steam_market_price_overview_url)

    unless response.success?
      Rails.logger.error "HTTParty request failed with code #{response.code}: #{response.message}"
      update(last_request_success: false)
      return false
    end


    json = JSON.parse(response.body)

    update(
      last_request_success: json["success"],
      last_request_time: Time.current,
      lowest_price: json["lowest_price"],
      median_price: json["median_price"],
      volume_sold: json["volume"]&.to_s&.gsub(/\D/, "")&.to_i,
      last_request_response: json
    )
  rescue JSON::ParserError => e
    Rails.logger.error "JSON parsing failed: #{e.message}"
    update(last_request_success: false)
    false
  rescue StandardError => e
    Rails.logger.error "Unexpected error in SteamMarketPriceOverview.update: #{e.message}"
    update(last_request_success: false)
    false
  end

  private

  BASE_STEAM_API_URL = "https://steamcommunity.com/market/priceoverview/?country=DE&currency=3&appid=730&market_hash_name=".freeze
end
