module CheckoutsHelper
  def active_step_class(current_step)
    'active' unless future_step?(current_step)
  end

  def current_delivery?(delivery)
    params[:delivery_id] == delivery.id || current_order.delivery == delivery
  end
end
