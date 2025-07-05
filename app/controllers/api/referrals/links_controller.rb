class Api::Referrals::LinksController < ActionController::API
  def create
    user = User.find_or_create_by(email: params[:email])
    campaign = Campaign.find(params[:campaign_id])
    referral = Referral.find_or_create_by(user: user, campaign: campaign)

    render json: {
      referral_url: "https://viraltrust.com/r/#{referral.code}"
    }, status: :ok
  rescue => e
    render json: { error: e.message }, status: :bad_request
  end
end
