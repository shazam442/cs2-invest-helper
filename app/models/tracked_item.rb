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

  def sync_skinport_listings
    SkinportAPIAccessor.sync_items_to_file
    skinport_listings_catalog = JSON.parse(File.read(SkinportAPIAccessor.response_file_path))

    # iterate over catalog and create or update skinport_listing record for each object that has a market_hash_name which includes the value of the tracked_item's market_hash_name
    # when the listing is created or updated successfully it should be removed from the catalog
    new_catalog = skinport_listings_catalog.reject do |listing_data|
      name = listing_data["market_hash_name"]
      next unless name.include?(market_hash_name)
      next unless is_stattrak?(name) == stattrak
      next unless is_souvenir?(name) == souvenir

      update_skinport_listing(listing_data)
    end
    # rerwire the file with the remaining listings
    File.open(SkinportAPIAccessor.response_file_path, "w") do |file|
      file.write(JSON.pretty_generate(new_catalog))
    end
  end

  def update_skinport_listing(listing_data)
    skinport_listing.update!(
      currency: listing_data["currency"],
      suggested_price: listing_data["suggested_price"],
      item_page: listing_data["item_page"],
      market_page: listing_data["market_page"],
      min_price: listing_data["min_price"],
      max_price: listing_data["max_price"],
      mean_price: listing_data["mean_price"],
      median_price: listing_data["median_price"],
      quantity: listing_data["quantity"],
      posted_on_market_at: Time.at(listing_data["created_at"]),
      edited_on_market_at: Time.at(listing_data["updated_at"])
    )
  end

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
