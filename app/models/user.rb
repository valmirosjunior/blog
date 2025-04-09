class User < ApplicationRecord
  belongs_to :company

  scope :by_company, -> (id) { where(company: id) if id.present?  }
  scope :by_username, -> (username) { where("username LIKE ?", "%#{username}%") if username.present? }
end
