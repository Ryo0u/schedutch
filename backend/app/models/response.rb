class Response < ApplicationRecord
  belongs_to :user
  belongs_to :candidate

  validates :status, presence: true
  validates :user_id, uniqueness: { scope: [:candidate_id, :start_time] }
end
