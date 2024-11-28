class SkinportListing < ApplicationRecord
  belongs_to :tracked_item

  validates :tracked_item, presence: true

  def market_name = "skinport".freeze
end
