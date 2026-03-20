FactoryBot.define do
  factory :user do
    name { "山田太郎" }
    password { "userpass123" }
    password_confirmation { "userpass123" }
    association :event
  end
end
