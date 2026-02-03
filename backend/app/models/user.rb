class User < ApplicationRecord
  has_secure_password
  
  belongs_to :event
  has_many :responses, dependent: :destroy
  
  validates :name, presence: true 
end
