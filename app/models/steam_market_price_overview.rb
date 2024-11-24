class SteamMarketPriceOverview < ApplicationRecord
  belongs_to :tracked_item

  attribute :last_request_success, :boolean, default: false
  attribute :last_request_response, :json, default: {}

  after_create :fetch_steam_api_data

  validates :tracked_item, presence: true
  validate :last_request_response_is_hash, if: -> { last_request_response.present? }

  def api_url
    BASE_STEAM_API_URL + tracked_item.uri_encoded_market_hash_name
  end

  private

  def last_request_response_is_hash
    return if last_request_response.is_a?(Hash)

    errors.add(:last_request_response, "must be saved as a Hash but was a #{last_request_response.class}")
  end

  BASE_STEAM_API_URL = "https://steamcommunity.com/market/priceoverview/?country=DE&currency=3&appid=730&market_hash_name=".freeze
end