class User < ApplicationRecord
  belongs_to :company

  scope :by_company, ->(company_id) { where(company_id: company_id) if company_id.present? }
  scope :by_username, ->(username) { where("username LIKE ?", "%#{username}%") if username.present? }
end
