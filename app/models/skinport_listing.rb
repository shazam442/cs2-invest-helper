class SkinportListing < ApplicationRecord
  belongs_to :tracked_item

  validates :tracked_item, presence: true

  def sync
    SkinportListingSyncService.new(self).sync_skinport_listings_file_to_db
  end
end
