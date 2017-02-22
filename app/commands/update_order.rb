class UpdateOrder < Rectify::Command
  attr_reader :order, :params, :coupon_form

  def initialize(order, params)
    @order = order
    @params = params
  end

  def call
    if coupon_valid? && update_order
      type = params[:to_checkout] ? :to_checkout : :valid
      broadcast type
    else
      broadcast :invalid, coupon_form
    end
  end

  private

  def order_params
    params.require(:order).permit(order_items_attributes: [:id, :quantity])
  end

  def update_order
    order.coupon = coupon if coupon.present?
    order.update_attributes(order_params)
  end

  def coupon_valid?
    coupon_form.valid?(order)
  end

  def coupon
    return unless params[:order][:coupon]
    @coupon ||= Coupon.find_by_code(params[:order][:coupon][:code])
  end

  def coupon_form
    @coupon_form ||= CouponForm.from_params params[:order]
  end
end
