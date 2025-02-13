class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :redirect_if_signed_in
  before_action :current_user_role

  protected
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:firstname, :lastname, :phone_no, :gst_no, :pan_no, :address, :role])
  end

  def redirect_if_signed_in
    if user_signed_in? && request.path == root_path
      redirect_to items_path(current_user)
    end
  end

  def current_user_role
    if current_user.present?
      role = current_user.role
    end
  end
end
