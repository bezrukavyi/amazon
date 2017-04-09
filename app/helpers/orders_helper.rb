module OrdersHelper
  def state_title
    title = params[:state].blank? ? :all : params[:state]
    t("orders.index.states.#{title}")
  end

  def state_klass(order)
    order.delivered? ? 'text-success' : 'in-grey-900'
  end

  def order_state_path(order)
    order.processing? ? edit_cart_path : order_path(order)
  end

  def use_base_address_param
    current_order.use_base_address || params[:use_base_address]
  end

  def coupon_options(field)
    return {} if field.object.errors.present?
    { input_html: { value: '' } }
  end
end
