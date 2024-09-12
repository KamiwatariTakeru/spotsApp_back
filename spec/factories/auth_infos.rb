# spec/factories/auth_infos.rb
FactoryBot.define do
  factory :auth_info do
    id { SecureRandom.hex(10) }
    provider { "google" }  # または、適切なプロバイダ名を設定
    association :user  # Userファクトリが必要です

    # 必要に応じて、他の属性もここに追加できます
  end
end
