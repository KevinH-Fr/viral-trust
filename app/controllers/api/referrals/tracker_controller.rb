# app/controllers/api/referrals/tracker_controller.rb
class Api::Referrals::TrackerController < ActionController::API
  def create
    code = params[:ref_code]
    referral = Referral.find_by(code: code)

    if referral
      referral.update(ip: request.remote_ip, clicked_at: Time.current)
      render json: { status: 'ok' }, status: :ok
    else
      render json: { error: 'Referral code not found' }, status: :not_found
    end
  end
end
