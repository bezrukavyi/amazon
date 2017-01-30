class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @states = Order.aasm.states.map(&:name).unshift(:all)
    @orders = filtered_orders
  end

  def show
    @order = Order.find_by(id: params[:id], user: current_user)
    redirect_to orders_path, alert: t('orders.show.not_found') unless @order
  end

  private

  def filtered_orders
    orders = Order.where(user: current_user)
    orders = default_sort? ? orders : orders.send("#{params[:state]}")
  end

  def default_sort?
    return true unless params[:state]
    params[:state] == @states.first
  end

end
