class User < ApplicationRecord
  belongs_to :company

  scope :by_company, ->(company_id) { where(company_id: company_id) if company_id.present? }
  scope :by_username, ->(username) { where("username LIKE ?", "%#{username}%") if username.present? }

  validates :display_name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, length: { minimum: 3, maximum: 20 }, uniqueness: { case_sensitive: false }
end
