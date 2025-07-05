class ReferralsController < ApplicationController
  before_action :require_login

  def create
    campaign = Campaign.find(params[:campaign_id])
    referral = Referral.find_or_create_by(user: current_user, campaign: campaign)

    redirect_to request.referer || root_path, notice: "Referral link generated!"
  end
end
