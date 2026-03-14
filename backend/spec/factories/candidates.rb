FactoryBot.define do
  factory :candidate do
    start_time { Time.current.tomorrow.change(hour: 6) }
    end_time { Time.current.tomorrow.change(hour: 21) }
    association :event
  end
end