class Company < ApplicationRecord
  has_many :users, dependent: :restrict_with_error
end
