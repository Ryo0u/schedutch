class User < ApplicationRecord
  has_secure_password

  belongs_to :event
  has_many :responses, dependent: :delete_all

  validates :name, presence: true
end
