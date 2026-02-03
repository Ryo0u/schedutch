class TimeSlot < ApplicationRecord
  belongs_to :candidate
  has_many :response, dependent: :destroy
end
