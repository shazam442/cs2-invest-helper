class TrackedItem < ApplicationRecord
  has_one :steam_market_price_overview, dependent: :destroy

  before_create :build_steam_market_price_overview

  enum wear: {
    "non_wear_item": 0,
    "Factory New": 1,
    "Minimal Wear": 2,
    "Field-Tested": 3,
    "Well-Worn": 4,
    "Battle-Scarred": 5
    }, _default: 0

    validates :wear, inclusion: { in: wears.keys }
    validates :name, presence: true, allow_blank: false
    validates :steam_market_price_overview, presence: true

    delegate :lowest_price, :median_price, :volume_sold, :last_request_success, :last_request_time, :last_request_response, to: :steam_market_price_overview, prefix: :steam

  def update_price_overviews
    steam_market_price_overview.fetch_steam_api_data
  end

  def all_price_overviews
    [ steam_market_price_overview ] # more to come
  end

  def steam_market_url
    "https://steamcommunity.com/market/listings/730/#{uri_encoded_market_hash_name}"
  end

  def image_url
    "https://api.steamapis.com/image/item/730/#{uri_encoded_market_hash_name}"
  end

  def short_wear
    case wear
    when "Factory New"
      "FN"
    when "Minimal Wear"
      "MW"
    when "Field-Tested"
      "FT"
    when "Well-Worn"
      "WW"
    when "Battle-Scarred"
      "BS"
    end
  end

  def market_hash_name
    return name if non_wear_item?
    "#{name} (#{wear})"
  end

  def uri_encoded_market_hash_name
    URI::Parser.new.escape(market_hash_name).gsub("&", "%26")
  end
end
