include TrackedItemsHelper

class TrackedItem < ApplicationRecord
  has_one :steam_listing, dependent: :destroy
  has_one :skinport_listing, dependent: :destroy

  enum :wear, {
    non_wear_item: 0,
    factory_new: 1,
    minimal_wear: 2,
    field_tested: 3,
    well_worn: 4,
    battle_scarred: 5
  }, default: :non_wear_item

    validates :wear, inclusion: { in: wears.keys }
    validates :name, presence: true, allow_blank: false
    validates :stattrak, inclusion: { in: [ true, false ] }
    validates :souvenir, inclusion: { in: [ true, false ] }
    validates_associated :steam_listing, presence: true

  def steam_url = steam_listing.url
  def steam_price_overview_url = steam_listing.price_overview_url
  def image_url = steam_listing.image_url

  def wear_name_short
    {
      factory_new: "FN",
      minimal_wear: "MW",
      field_tested: "FT",
      well_worn: "WW",
      battle_scarred: "BS"
    }[wear.to_sym]
  end

  def wear_name_long
    {
      factory_new: "Factory New",
      minimal_wear: "Minimal Wear",
      field_tested: "Field-Tested",
      well_worn: "Well-Worn",
      battle_scarred: "Battle-Scarred"
    }[wear.to_sym]
  end

  def market_hash_name
    return name if non_wear_item?
    "#{name} (#{wear_name_long})"
  end
end
