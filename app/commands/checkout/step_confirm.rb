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
      use_coupon
      send_mail
    end
    broadcast :valid
  end

  private

  def update_order
    order.confirm!
  end

  def use_coupon
    return unless order.coupon
    order.coupon.use!
  end

  def send_mail
    CheckoutMailer.complete(user, order).deliver
  end

end
