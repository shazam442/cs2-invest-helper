class SkinportListingSyncService
  include ApiHelper

  def initialize(tracked_item)
    @tracked_item = tracked_item
  end

  def sync
    listings_data = SkinportApiService.new.fetch_web_listings

    to_json_file(listings_data, skinport_listings_file_path) if listings_data.any?
    persist_listings_file_to_db
  end

  private

  def persist_listings_file_to_db
    fp = skinport_listings_file_path

    catalog = JSON.parse(File.read(fp))

    updated_listings = catalog.select do |listing|
      next unless matches_tracked_item?(listing)
      update_tracked_item(listing)
    end
    return false if not updated_listings.any?

    catalog_without_processed_listings = catalog - updated_listings

    # remove the listings that were persisted to the db
    to_json_file(catalog_without_processed_listings, fp)
    true
  end

  def matches_tracked_item?(listing_data)
    name = listing_data["market_hash_name"]
    name.include?(@tracked_item.market_hash_name) &&
      is_stattrak?(name) == @tracked_item.stattrak &&
      is_souvenir?(name) == @tracked_item.souvenir
  end

  def update_tracked_item(listing_data)
    @tracked_item.skinport_listing.update(
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
