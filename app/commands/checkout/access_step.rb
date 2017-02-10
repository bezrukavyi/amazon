class Checkout::AccessStep < Rectify::Command
  attr_reader :order, :user, :step

  def initialize(order, user, step)
    @order = order
    @user = user
    @step = step
  end

  def call
    return broadcast(:empty_cart) if order.items_count.zero? && step != :complete
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
    return true if order.items_count.zero?
    confirm_accessed? && order.in_progress?
  end
end
