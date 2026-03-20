class Candidate < ApplicationRecord
  belongs_to :event
  has_many :responses, dependent: :delete_all
  
  validates :start_time, presence: true
  validates :end_time, presence: true
end
