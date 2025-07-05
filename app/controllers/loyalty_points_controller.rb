class LoyaltyPointsController < ApplicationController
 # before_action :authenticate_user!

  def index
    @loyalty_points = current_user.loyalty_points.includes(:campaign)
  end

  def swap
    from = LoyaltyPoint.find(params[:from_id])
    to_campaign = Campaign.find(params[:to_campaign_id])
    to = LoyaltyPoint.find_or_create_by(user: current_user, campaign: to_campaign)

    swap_amount = [from.balance, 100].min # simulate max 100 point per swap
    if swap_amount > 0
      from.update(balance: from.balance - swap_amount)
      to.update(balance: to.balance + swap_amount)
      flash[:success] = "✅ You swapped #{swap_amount} points from #{from.campaign.title} to #{to.campaign.title}."
    else
      flash[:warning] = "You don't have enough points to swap."
    end

    redirect_to loyalty_points_path
  end
end
