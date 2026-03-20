class Event < ApplicationRecord
  has_secure_password
  
  has_many :users
  has_many :candidates
  has_many :responses, through: :users
  
  before_destroy do
    Response.where(candidate_id: candidates.select(:id)).delete_all
    User.where(event_id: id).delete_all
    Candidate.where(event_id: id).delete_all
  end
  
  accepts_nested_attributes_for :candidates, allow_destroy: true
  
  validates :title, presence: true
  validates :url_token, presence: true, uniqueness: true
  
  before_validation :generate_url_token, on: :create
  
  def generate_url_token
    self.url_token ||= loop do
      token = SecureRandom.urlsafe_base64
      break token unless Event.exists?(url_token: token)
    end
  end
end
