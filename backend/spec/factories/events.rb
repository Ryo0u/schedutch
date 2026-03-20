FactoryBot.define do
  factory :event do
    title { "test-event" }
    password { "eventpass123" }
    password_confirmation { "eventpass123" }
    url_token { SecureRandom.hex(10) }
  end
end
