class Checkout::StepConfirm < Rectify::Command

  attr_reader :order, :user, :confirm

  def initialize(options)
    @order = options[:order]
    @user = options[:user]
    @confirm = options[:confirm]
  end

  def call
    return broadcast(:invalid) if confirm.blank? || user.blank?
    transaction do
      update_order
      send_mail
      clear_order_session
    end
    broadcast :valid
  end

  private

  def update_order
    order.confirm
    order.update_attributes(user: user)
  end

  def send_mail
    CheckoutMailer.complete(user, order).deliver
  end

  def clear_order_session
    session[:order_id] = nil
  end

end
