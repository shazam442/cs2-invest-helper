class SkinportListingSyncService < BaseSkinportService
  def initialize(tracked_item)
    @tracked_item = tracked_item
  end

  def sync
    sync_skinport_listings_file_to_db
  end

  private

  def sync_skinport_listings_file_to_db
    return false if not SkinportAPIService.new.sync_skinport_items_to_file
    catalog = JSON.parse(File.read(skinport_listings_file_path))

    catalog_without_processed_listings = catalog.reject { |listing| process_listing(listing) }

    to_json_file(catalog_without_processed_listings)
    true
  end

  def process_listing(listing_data)
    return false unless matches_tracked_item?(listing_data)

    update_tracked_item(listing_data)
  end

  def matches_tracked_item?(listing_data)
    name = listing_data["market_hash_name"]
    name.include?(@tracked_item.market_hash_name) &&
      is_stattrak?(name) == @tracked_item.stattrak &&
      is_souvenir?(name) == @tracked_item.souvenir
  end

  def update_tracked_item(listing_data)
    @tracked_item.skinport_listing.update!(
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
end
