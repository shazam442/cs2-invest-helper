class TrackedItem < ApplicationRecord
  include ApiHelper
  include ViewHelper

  has_one :steam_listing, dependent: :destroy
  has_one :skinport_listing, dependent: :destroy
  has_many :api_requests, dependent: :destroy

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
  validates_associated :skinport_listing, presence: true

  def steam_api_url = steam_api_price_overview_url(self)
  def steam_url = steam_market_url(self)
  def image_url = steam_market_image_url(self)

  def intermarket_min_price_listing
    [ steam_listing, skinport_listing ].min_by { |listing| listing.min_price || Float::INFINITY }
  end

  def intermarket_min_price_market_name = intermarket_min_price_listing.market_name

  def intermarket_min_price = intermarket_min_price_listing.min_price

  def last_steam_request = api_requests.to_steam.last

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

  def uri_encoded_market_hash_name
    URI.encode_uri_component(market_hash_name)
  end

  private

  def build_associations
    build_steam_listing
    build_skinport_listing
  end
end
