class Event < ApplicationRecord
  has_secure_password
  
  has_many :candidates, dependent: :destroy
  has_many :users, dependent: :destroy
  
  validates :title, presence: true
  validates :url_token, presence: true, uniqueness: true
  
  before_validation :generate_url_token, on: :create
  
  def generate_url_token
    self.url_token ||= loop do
      token = SecureRandom.urlsafe_base64
      bread token unless Event.exist?(url_token: token)
    end
  end
  
end
