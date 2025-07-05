class FlowAuthController < ApplicationController
  protect_from_forgery with: :null_session

  def authenticate
    raw_payload = params[:authorization_payload] || params.dig(:flow_auth, :authorization_payload)

    unless raw_payload.present?
      puts "[FlowAuth] ❌ Missing authorization payload"
      return render json: { error: "Missing authorization payload" }, status: :bad_request
    end

    payload = raw_payload.to_unsafe_h rescue raw_payload.to_h rescue nil

    unless payload.is_a?(Hash)
      puts "[FlowAuth] ❌ Payload is not a valid hash"
      return render json: { error: "Authorization payload is not a valid hash" }, status: :bad_request
    end

    flow_address = payload["addr"]
    services     = payload["services"]

    unless flow_address.present? && services.is_a?(Array)
      puts "[FlowAuth] ❌ Invalid Flow address or services"
      return render json: { error: 'Invalid Flow data' }, status: :bad_request
    end

    signature = services.find { |s| s["type"] == "user-signature" }
    unless signature
      puts "[FlowAuth] ❌ User signature service missing"
      return render json: { error: "User signature service not found" }, status: :bad_request
    end

    user = User.find_or_create_by(flow_address: flow_address)

    if user.persisted?
      if user.created_at == user.updated_at
        puts "[FlowAuth] ✅ New user created: ID=#{user.id}, Flow Address=#{user.flow_address}"
      else
        puts "[FlowAuth] 🔁 Existing user found: ID=#{user.id}, Flow Address=#{user.flow_address}"
      end
    else
      puts "[FlowAuth] ❌ User not persisted (unexpected)"
    end

    session[:user_id] = user.id
    puts "[FlowAuth] 💾 Session set for user ID=#{user.id}"

    render json: {
      message: "Authentication successful",
      redirect_to: Rails.application.routes.url_helpers.edit_user_path(user)
    }, status: :ok
    
  rescue => e
    Rails.logger.error("Flow auth error: #{e.class.name} - #{e.message}")
    puts "[FlowAuth] ❌ Exception raised: #{e.class} - #{e.message}"
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
