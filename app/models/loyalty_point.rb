# app/models/loyalty_point.rb
class LoyaltyPoint < ApplicationRecord
  belongs_to :user
  belongs_to :campaign

  validates :balance, numericality: { greater_than_or_equal_to: 0 }
end
