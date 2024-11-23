class TrackedItem < ApplicationRecord
  after_initialize :set_defaults

  validates :name, presence: true, allow_blank: false
  validate :is_hash, if: -> { price_overview_json.present? }

  enum wear: {
    "non_wear_item": 0,
    "Factory New": 1,
    "Minimal Wear": 2,
    "Field-Tested": 3,
    "Well-Worn": 4,
    "Battle-Scarred": 5
  }, _default: 0
  validates :wear, inclusion: { in: wears.keys }

  def update_price_overview_json
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
      price_overview_json: json
    )
  rescue JSON::ParserError => e
    Rails.logger.error "JSON parsing failed: #{e.message}"
    update(last_request_success: false)
    false
  rescue StandardError => e
    Rails.logger.error "Unexpected error in update_price_overview_json: #{e.message}"
    update(last_request_success: false)
    false
  end

  def steam_market_price_overview_url
    BASE_STEAM_API_URL + uri_encoded_market_hash_name
  end

  def steam_market_url
    "https://steamcommunity.com/market/listings/730/#{uri_encoded_market_hash_name}"
  end

  def market_hash_name
    return name if non_wear_item?
    "#{name} (#{wear})"
  end

  private

  def set_defaults
    self.price_overview_json ||= {}
    self.last_request_success false if last_request_success.nil?
  end

  def is_hash
    return if price_overview_json.is_a?(Hash)

    errors.add(:price_overview_json, :invalid_data_type, message: "must be a hash")
  end

  def uri_encoded_market_hash_name
    URI::Parser.new.escape(market_hash_name).gsub("&", "%26")
  end

  BASE_STEAM_API_URL = "https://steamcommunity.com/market/priceoverview/?country=DE&currency=3&appid=730&market_hash_name=".freeze
end
