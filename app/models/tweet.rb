class Tweet < ApplicationRecord
  belongs_to :user

  scope :newest_first, -> { order(created_at: :desc) }
  scope :by_username, ->(username) {
    joins(:user).where(users: { username: username }) if username.present?
  }
end
