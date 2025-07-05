class Campaign < ApplicationRecord
  belongs_to :user
  has_one_attached :image

  validates :title, :description, :total_reward_amount, presence: true
  validates :total_reward_amount, numericality: { greater_than: 0 }

end
