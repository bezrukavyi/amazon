class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @states = Order.aasm.states.map(&:name).unshift(:all)
    @orders = filtered_orders
  end

  private

  def filtered_orders
    orders = Order.where(user: current_user).includes(:coupon, :delivery, :order_items)
    orders = default_sort? ? orders : orders.send("#{params[:state]}")
  end

  def default_sort?
    return true unless params[:state]
    params[:state] == @states.first
  end

end
