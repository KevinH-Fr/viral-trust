class FlowAuthController < ApplicationController
  protect_from_forgery with: :null_session

  def authenticate
    raw_payload = params[:authorization_payload] || params.dig(:flow_auth, :authorization_payload)

    unless raw_payload.present?
      return render json: { error: "Missing authorization payload" }, status: :bad_request
    end

    payload = raw_payload.to_unsafe_h rescue raw_payload.to_h rescue nil

    unless payload.is_a?(Hash)
      return render json: { error: "Authorization payload is not a valid hash" }, status: :bad_request
    end

    flow_address = payload["addr"]
    services     = payload["services"]

    unless flow_address.present? && services.is_a?(Array)
      return render json: { error: 'Invalid Flow data' }, status: :bad_request
    end

    signature = services.find { |s| s["type"] == "user-signature" }
    unless signature
      return render json: { error: "User signature service not found" }, status: :bad_request
    end

    user = User.find_or_create_by(flow_address: flow_address)

    session[:user_id] = user.id

    render json: { message: "Authentication successful" }, status: :ok
  rescue => e
    Rails.logger.error("Flow auth error: #{e.class.name} - #{e.message}")
    render json: { error: "Internal Server Error" }, status: :internal_server_error
  end

  def logout
    reset_session
    cookies.delete(:auth_token)
    render json: { message: 'Logout successful' }, status: :ok
  rescue => e
    Rails.logger.error("Logout error: #{e.class.name} - #{e.message}")
    render json: { error: 'Internal Server Error' }, status: :internal_server_error
  end
end
