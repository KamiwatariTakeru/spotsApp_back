class AuthInfo < ApplicationRecord
  belongs_to :user
  validates :id, presence: true, uniqueness: true
end
