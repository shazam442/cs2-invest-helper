class SkinportListing < ApplicationRecord
  belongs_to :tracked_item

  validates :tracked_item, presence: true
end
