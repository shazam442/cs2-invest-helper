class TrackedItem < ApplicationRecord
  has_one :steam_market_price_overview, dependent: :destroy

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
    validates_associated :steam_market_price_overview, presence: true

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
    {
      "Factory New" => "FN",
      "Minimal Wear" => "MW",
      "Field-Tested" => "FT",
      "Well-Worn" => "WW",
      "Battle-Scarred" => "BS"
    }[wear]
  end

  def market_hash_name
    return name if non_wear_item?
    "#{name} (#{wear})"
  end

  def uri_encoded_market_hash_name
    URI::Parser.new.escape(market_hash_name).gsub("&", "%26")
  end
end
