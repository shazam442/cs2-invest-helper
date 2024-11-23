class TrackedItem < ApplicationRecord
  has_one :steam_market_price_overview, dependent: :destroy

  after_initialize :set_defaults

  validates :name, presence: true, allow_blank: false

  enum wear: {
    "non_wear_item": 0,
    "Factory New": 1,
    "Minimal Wear": 2,
    "Field-Tested": 3,
    "Well-Worn": 4,
    "Battle-Scarred": 5
  }, _default: 0
  validates :wear, inclusion: { in: wears.keys }

  def update_price_overviews
    steam_market_price_overview.update
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

  private

  def uri_encoded_market_hash_name
    URI::Parser.new.escape(market_hash_name).gsub("&", "%26")
  end
end
