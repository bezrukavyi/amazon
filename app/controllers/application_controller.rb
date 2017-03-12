class ApplicationController < ActionController::Base
  include Corzinus::Controllable
  helper Corzinus::Engine.helpers

  protect_from_forgery with: :exception

  include Localable
  include Flashable

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_categories

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_url, alert: exception.message
  end

  def configure_permitted_parameters
    update_attrs = [:password, :password_confirmation, :current_password]
    devise_parameter_sanitizer.permit :account_update, keys: update_attrs
  end

  helper_method :session_user_return

  def fast_authenticate_user!
    return if user_signed_in?
    session_user_return
    redirect_to main_app.sign_up_path(type: 'fast')
  end

  def session_user_return
    session['user_return_to'] = request.fullpath
  end

  def authenticate_corzinus_person!
    fast_authenticate_user!
  end

  private

  def set_categories
    @categories = Category.select(:id, :title, :books_count)
  end
end
