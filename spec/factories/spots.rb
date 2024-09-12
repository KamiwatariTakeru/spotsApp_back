FactoryBot.define do
  factory :spot do
    id { SecureRandom.uuid }
    name { "Test User" }
    address { "Test address" }
    stars_sum { 1 }
    stars_avg { 1 }
    latitude { 000 }
    longitude { 000 }
  end
end
