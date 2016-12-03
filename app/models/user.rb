class User < ApplicationRecord
  has_secure_token
  has_secure_password

  validates :full_name, presence: true
end
