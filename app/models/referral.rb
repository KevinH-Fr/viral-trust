class Referral < ApplicationRecord
  belongs_to :user  # ambassador
  belongs_to :campaign

  before_create :generate_code

  def generate_code
    self.code = "ref_#{SecureRandom.hex(4)}" unless code.present?
  end
end
