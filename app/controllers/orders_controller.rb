class OrdersController < ApplicationController
  load_and_authorize_resource through: :current_user, only: [:show, :index]

  def index
    @states = Order.assm_states.unshift(:all)
    @orders = @orders.not_empty.order(created_at: :desc)
    @orders = @orders.send(params[:state]) unless default_state?
  end

  private

  def default_state?
    return true unless params[:state]
    params[:state] == @states.first
  end
end
