FactoryBot.define do
  factory :tweet do
    body { Faker::Lorem.sentence }
    user { association(:user) }
  end
end
