FactoryBot.define do
  factory :response do
    association :user
    association :candidate
    start_time { Time.current.tomorrow.change(hour: 19) }
    status { 3 } # 回答は × という意味 
  end
end