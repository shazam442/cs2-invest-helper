class SteamMarketPriceOverview < ApplicationRecord
  belongs_to :tracked_item

  attribute :last_request_success, :boolean, default: false
  after_create :fetch_steam_api_data

  validates :tracked_item, presence: true
  validate :last_request_response_is_hash

  def api_url
    BASE_STEAM_API_URL + tracked_item.uri_encoded_market_hash_name
  end

  def fetch_steam_api_data
    response = HTTParty.get(api_url)

    unless response.success?
      Rails.logger.error "HTTParty request failed with code #{response.code}: #{response.message}"
      update(last_request_success: false)
      return false
    end

    json = JSON.parse(response.body)
    # strip of currency symbol and convert to float
    lowest_price = json["lowest_price"]&.gsub(/[^0-9],/, "")&.gsub(",", ".")&.to_f
    median_price = json["median_price"]&.gsub(/[^0-9],/, "")&.gsub(",", ".")&.to_f
    volume_sold = json["volume"]&.gsub(/\D/, "")&.to_i
    success = json["success"]

    update(
      lowest_price: lowest_price,
      median_price: median_price,
      volume_sold: volume_sold,
      last_request_response: json,
      last_request_success: success,
      last_request_time: Time.current
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

  def last_request_response_is_hash
    return if last_request_response.is_a?(Hash)

    errors.add(:last_request_response, "must be saved as a Hash (likely received string)")
  end

  BASE_STEAM_API_URL = "https://steamcommunity.com/market/priceoverview/?country=DE&currency=3&appid=730&market_hash_name=".freeze
end
