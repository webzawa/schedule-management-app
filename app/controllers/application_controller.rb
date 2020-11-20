# frozen_string_literal: true

class ApplicationController < ActionController::Base
  #CSRF対策
  protect_from_forgery with: :null_session
  before_action :configure_permitted_parameters, :if => :devise_controller?

  private

  # Before filters

  # Confirms an admin user.
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  protected

  def configure_permitted_parameters
    added_attrs = %i[username duty_hours email password password_confirmation]
    devise_parameter_sanitizer.permit :sign_up, :keys => added_attrs
    devise_parameter_sanitizer.permit :account_update, :keys => added_attrs
    devise_parameter_sanitizer.permit :sign_in, :keys => added_attrs
  end
end
