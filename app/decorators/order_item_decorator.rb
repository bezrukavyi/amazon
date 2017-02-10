class OrderItemDecorator < Draper::Decorator
  delegate_all

  def all_errors
    errors.full_messages.join('. ')
  end
end
