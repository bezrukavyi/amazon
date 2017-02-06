class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @states = Order.aasm.states.map(&:name).unshift(:all)
    @orders = Order.where(user: current_user).not_empty
    @orders = @orders.send("#{params[:state]}") unless default_sort?
  end

  def show
    @order = Order.find_by(id: params[:id], user: current_user)
    redirect_to orders_path, alert: t('flash.failure.order_found') unless @order
  end

  private

  def default_sort?
    return true unless params[:state]
    params[:state] == @states.first
  end

end
