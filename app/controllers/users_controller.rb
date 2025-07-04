class UsersController < ApplicationController
  def new
    @user = User.new(flow_address: session[:pending_flow_address])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      session.delete(:pending_flow_address)
      redirect_to root_path, notice: "Bienvenue !"
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:flow_address, :name, :email, :profile_pic, :role)
  end
end
