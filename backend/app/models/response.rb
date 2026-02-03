class Response < ApplicationRecord
  belongs_to :user
  belongs_to :time_slot
  
  validates :status, presence: ture
end
