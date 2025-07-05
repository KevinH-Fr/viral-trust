class User < ApplicationRecord
  validates :flow_address, presence: true, uniqueness: true

  has_many :campaigns

  has_many :loyalty_points, dependent: :destroy

  enum role: {
    ambassador: "ambassador",
    brand: "brand"
  }
end
