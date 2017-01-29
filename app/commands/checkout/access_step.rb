class Checkout::AccessStep < Rectify::Command

  attr_reader :order, :step

  def initialize(order, step)
    @order = order
    @step = step
  end

  def call
    return broadcast(:empty_cart) if order.cart_empty?
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

  def delivery_accessed?
    order.shipping.present? && order.billing.present?
  end

  def payment_accessed?
    delivery_accessed? && order.delivery.present?
  end

  def confirm_accessed?
    payment_accessed? && order.credit_card.present?
  end

  def complete_accessed?
    confirm_accessed? && order.in_progress?
  end


end
