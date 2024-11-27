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

  def self.seconds_until_next_skinport_request
    last_request_time = to_skinport.last&.request_time

    return 0 if last_request_time.nil?
    seconds = 5.minutes - [ Time.current - last_request_time, 5.minutes ].min
    seconds.to_i
  end

  def  self.five_minutes_passed_since_last_skinport_request?
    last_request_time = to_skinport.last&.request_time

    return true if last_request_time.nil?
    last_request_time < 5.minutes.ago
  end
end
