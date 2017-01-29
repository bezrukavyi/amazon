class UpdateOrder < Rectify::Command

  attr_reader :order, :params, :coupon_form

  def initialize(options)
    @order = options[:order]
    @params = options[:params]
    @coupon_form = options[:coupon_form]
  end

  def call
    if coupon_valid? && update_order
      broadcast :valid
    else
      broadcast :invalid
    end
  end

  private

  def order_params
    @params.require(:order).permit(order_items_attributes: [:id, :quantity])
  end

  def update_order
    order.coupon = coupon
    order.update_attributes(order_params)
  end

  def coupon_valid?
    return true if coupon_form.blank?
    coupon_form.valid?
  end

  def coupon
    coupon_code = params[:order][:coupon][:code]
    if coupon_code.blank?
      order.coupon = nil
    else
      coupon = Coupon.find_by_code(coupon_code)
    end
  end

end
