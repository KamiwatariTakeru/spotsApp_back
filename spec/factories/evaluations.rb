FactoryBot.define do
  factory :evaluation do
    association :user
    association :spot
    starsAmount { 3 }  # または適切なデフォルト値
  end
end
