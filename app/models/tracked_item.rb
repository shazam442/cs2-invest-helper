class TrackedItem < ApplicationRecord
  has_one :steam_listing, dependent: :destroy

  enum :wear, "non_wear_item": 0,
    "Factory New": 1,
    "Minimal Wear": 2,
    "Field-Tested": 3,
    "Well-Worn": 4,
    "Battle-Scarred": 5, _default: 0

    validates :wear, inclusion: { in: wears.keys }
    validates :name, presence: true, allow_blank: false
    validates_associated :steam_listing, presence: true

  def steam_url = steam_listing.url
  def steam_price_overview_url = steam_listing.price_overview_url
  def image_url = steam_listing.image_url

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
end
