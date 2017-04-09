class DeliveryDecorator < Draper::Decorator
  delegate_all

  def duration
    [I18n.t('from'), min_days, I18n.t('to'), max_days, I18n.t('days')].join(' ')
  end

  def order_subtotal(order)
    order.calc_total_cost(:coupon) + price
  end
end
