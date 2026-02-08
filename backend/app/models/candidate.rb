class Candidate < ApplicationRecord
  belongs_to :event
  has_many :responses, dependent: :destroy
  
  validates :start_time, presence: true
  validates :end_time, presence: true
end
