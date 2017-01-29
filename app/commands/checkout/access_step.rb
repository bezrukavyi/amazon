class Checkout::AccessStep < Rectify::Command

  attr_reader :order, :step

  def initialize(order, step)
    @order = order
    @step = step
  end

  def call
    return broadcast(:not_allow) unless step && order
    allow? ? broadcast(:allow) : broadcast(:not_allow)
  end

  def allow?
    case step
    when :address then true
    when :delivery then delivery_accessed?
    when :payment then payment_accessed?
    when :confirm then confirm_accessed?
    when :complete then complete_accessed?
    end
  end

  private

  def order_complete?
    order.in_progress?
  end

  def delivery_accessed?
    return false if order_complete?
    order.shipping.present? && order.billing.present?
  end

  def payment_accessed?
    delivery_accessed? && order.delivery.present?
  end

  def confirm_accessed?
    payment_accessed? && order.credit_card.present?
  end

  def complete_accessed?
    order_complete? || confirm_accessed?
  end


end
