class Api::Referrals::TrackerController < ActionController::API
  def create
    code = params[:ref_code]
    referral = Referral.find_by(code: code)

    if referral
      referral.update(ip: request.remote_ip, clicked_at: Time.current)

      # call the smart contract via script Node.js
      recipient = referral.user.flow_address # or EVM address (flipside?)
      amount = 50
      private_key = ENV["EVM_PRIVATE_KEY"]

      if recipient.present? && private_key.present?
        output = `node app/javascript/web3/call_reward.js #{recipient} #{amount} #{private_key}`
        Rails.logger.info "[Rewarder] Smart contract response: #{output}"
      else
        Rails.logger.warn "[Rewarder] Missing recipient or private key – skipping reward call"
      end

      render json: { status: 'ok' }, status: :ok
    else
      render json: { error: 'Referral code not found' }, status: :not_found
    end
  end
end
