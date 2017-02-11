class ApplicationController < ActionController::Base
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

  helper_method :current_order

  def current_order
    @current_order ||= set_current_order
  end

  def fast_authenticate_user!
    return if user_signed_in?
    session['user_return_to'] = request.fullpath
    redirect_to sign_up_path(type: 'fast')
  end

  private

  def set_current_order
    order = Order.find_by(id: session[:order_id], state: 'processing') || Order.create
    order = current_user.order_in_processing.merge_order!(order) if current_user
    session[:order_id] = order.id
    order
  end

  def set_categories
    @categories = Category.select(:id, :title, :books_count)
  end
end
