class ApiRequest < ApplicationRecord
  attr_readonly :target_market, :target_url, :request_time, :request_body

  enum :market, {
    steam: 0,
    skinbaron: 1,
    skinport: 2
  }

  scope :to_steam, -> { where(market: :steam) }
  scope :to_skinbaron, -> { where(market: :skinbaron) }
  scope :to_skinport, -> { where(market: :skinport) }
end
