FactoryBot.define do
  factory :tweet do
    body { Faker::Lorem.sentence }
    user { create(:user) }
  end
end
