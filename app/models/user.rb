class User < ApplicationRecord
  encrypts :email
  validates :id, presence: true, uniqueness: true
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
