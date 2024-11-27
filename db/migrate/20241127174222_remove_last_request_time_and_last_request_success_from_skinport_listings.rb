class RemoveLastRequestTimeAndLastRequestSuccessFromSkinportListings < ActiveRecord::Migration[7.2]
  def change
    remove_column :skinport_listings, :last_request_time, :datetime
    remove_column :skinport_listings, :last_request_success, :datetime
    add_column :skinport_listings, :item_page, :string
    add_column :skinport_listings, :market_page, :string
  end
end
