FactoryBot.define do
  factory :response do
    association :user
    association :candidate
    start_time { Time.current.tomorrow.change(hour: 19) }
    # ステータスはリクエスト側で定義
  end
end
