# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]
  before_action :authenticate_user!, only: [:create]

  #GET /resource/sign_in
  def new
    super
  end

  #POST /resource/sign_in
  def create
    # @user = User.new(configure_sign_in_params)
   # user_id = current_user.id
    if current_user.role == "seller"
      #redirect_to user_items_path(current_user)

      redirect_to sellers_index_url(current_user)
      #redirect_to controller: 'sellers', action: 'index', user_id: current_user.id
    elsif current_user.role == "bidder"
      redirect_to bidders_url(current_user)
    end
    #redirect_to controller: "item", action: "index", id: 1
  end

 # DELETE /resource/sign_out
  def destroy
    super
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_in_params
    devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  end
end
