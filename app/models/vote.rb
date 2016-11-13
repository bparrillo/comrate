class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :commercial
  validates :user_id, presence: true
  validates :value, presence: true
end