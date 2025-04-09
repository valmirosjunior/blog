class Tweet < ApplicationRecord
  scope :newest_first, -> { order(created_at: :desc) }
end
