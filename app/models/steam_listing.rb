class SteamListing < ApplicationRecord
  belongs_to :tracked_item

  attribute :last_request_success, :boolean, default: false
  attribute :last_request_response, :json, default: {}

  after_create :sync_price

  validates :tracked_item, presence: true
  validate :last_request_response_is_hash, if: -> { last_request_response.present? }

  def url = "https://steamcommunity.com/market/listings/730/#{uri_encoded_market_hash_name}"
  def price_overview_url = "https://steamcommunity.com/market/priceoverview/?currency=3&appid=730&market_hash_name=#{uri_encoded_market_hash_name}"
  def image_url = "https://api.steamapis.com/image/item/730/#{uri_encoded_market_hash_name}"

  def sync_price
    data = SteamAPIService.fetch_price_overview(tracked_item)

    update(data)
  end

  private

  def uri_encoded_market_hash_name
    URI.encode_uri_component(tracked_item.market_hash_name)
  end

  def last_request_response_is_hash
    return if last_request_response.is_a?(Hash)

    errors.add(:last_request_response, "must be saved as a Hash but was a #{last_request_response.class}")
  end
end
