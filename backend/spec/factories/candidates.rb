FactoryBot.define do
  factory :candidate do
    sequence(:start_time) { |n| Time.current.tomorrow.advance(days: n).change(hour: 6) }
    sequence(:end_time)   { |n| Time.current.tomorrow.advance(days: n).change(hour: 21) }
    association :event
  end
end