class SteamListing < ApplicationRecord
  belongs_to :tracked_item

  after_create :sync_price

  validates :tracked_item, presence: true

  delegate :uri_encoded_market_hash_name, to: :tracked_item
end
