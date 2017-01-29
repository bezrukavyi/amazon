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

  helper_method :current_order

  def current_order
    @current_order ||= set_current_order
  end

  private

  def set_current_order
    order = Order.with_items_book.find_by(id: session[:order_id], state: 'processing') || Order.create
    session[:order_id] = order.id
    order
  end

end
