class Response < ApplicationRecord
  belongs_to :user
  belongs_to :candidate

  validates :status, presence: ture
end
