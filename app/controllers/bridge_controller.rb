class BridgeController < ApplicationController
  def index
    @campaigns = Campaign.where.not(brand_url: nil)
  end
end
