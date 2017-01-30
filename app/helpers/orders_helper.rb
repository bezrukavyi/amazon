module OrdersHelper

  def state_title
    title = params[:state].blank? ? :all : params[:state]
    t("orders.index.states.#{title}")
  end

  def state_klass(order)
    order.delivered? ? 'text-success' : 'in-grey-900'
  end

  def order_state_path(order)
    order.processing? ? cart_path : order_path(order)
  end

end
