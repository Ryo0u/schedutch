class User < ApplicationRecord
  has_secure_password
  
  belongs_to :event
  has_many :responses
  
  validates :name, presence: true 
end
