class CampaignsController < ApplicationController
 # before_action :require_login
 # before_action :ensure_brand!

  def new
    @campaign = current_user.campaigns.new
  end

  def create
    @campaign = current_user.campaigns.new(campaign_params)
    if @campaign.save
      redirect_to @campaign, notice: "Campaign created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @campaign = Campaign.find(params[:id])
  end

  private

  def campaign_params
    params.require(:campaign).permit(:title, :description, :brand_url, :image, :total_reward_amount)
  end

  def ensure_brand!
    unless current_user.role == "brand"
      redirect_to root_path, alert: "Only brand users can create campaigns."
    end
  end
end
