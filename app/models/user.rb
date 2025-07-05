class User < ApplicationRecord
  validates :flow_address, presence: true, uniqueness: true

  has_many :campaigns

  enum role: {
    ambassador: "ambassador",
    brand: "brand"
  }
end
