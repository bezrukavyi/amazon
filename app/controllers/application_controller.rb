class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  include Localable

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to main_app.root_url, :alert => exception.message
  end

  def configure_permitted_parameters
    update_attrs = [:password, :password_confirmation, :current_password]
    devise_parameter_sanitizer.permit :account_update, keys: update_attrs
  end

  def current_order
    if current_user.blank?
      order = Order.find_by_id(session[:order_id]) || Order.create
      session[:order_id] = order.id
    else
      order = current_user.order_in_processing
    end
    order
  end

end
