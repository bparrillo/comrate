class ComPayment < ApplicationRecord
  belongs_to :commercial
  validates :card_type, presence: true
  validates :number, presence: true
  validates :expire_month, presence: true
  validates :expire_year, presence: true
  validates :cvv2, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :address, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :postal_code, presence: true
  validates :country_code, presence: true
end
