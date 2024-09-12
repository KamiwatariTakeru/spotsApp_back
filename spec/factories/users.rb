FactoryBot.define do
  factory :user do
    id { SecureRandom.uuid }
    email { "user@example.com" }
    name { "Test User" }
  end
end
