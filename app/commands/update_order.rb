class UpdateOrder < Rectify::Command
  attr_reader :order, :params, :coupon_form

  def initialize(order, params)
    @order = order
    @params = params
  end

  def call
    if coupon_valid? && update_order
      broadcast :valid
    else
      broadcast :invalid, coupon_form
    end
  end

  private

  def order_params
    params.require(:order).permit(order_items_attributes: [:id, :quantity])
  end

  def update_order
    order.coupon = coupon
    order.update_attributes(order_params)
  end

  def coupon_valid?
    return true if coupon.present? && coupon == order.coupon
    coupon_form.valid?
  end

  def coupon
    return unless params[:order][:coupon]
    @coupon ||= Coupon.find_by_code(params[:order][:coupon][:code])
  end

  def coupon_form
    @coupon_form ||= CouponForm.from_params params[:order]
  end
end
