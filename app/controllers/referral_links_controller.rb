class ReferralLinksController < ApplicationController
  def redirect
    referral = Referral.find_by(code: params[:code])
    if referral
      # Log the click
      referral.update(clicked_at: Time.current)
      brand_url = referral.campaign.brand_url # à ajouter dans campaign
      redirect_to "#{brand_url}?via=#{referral.code}"
    else
      redirect_to root_path, alert: "Invalid referral link"
    end
  end
end
