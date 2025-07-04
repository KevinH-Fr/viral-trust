class User < ApplicationRecord
  validates :flow_address, presence: true, uniqueness: true
  validates :role, inclusion: { in: %w[ambassador brand] }

  enum role: {
    ambassador: "ambassador",
    brand: "brand"
  }
end
