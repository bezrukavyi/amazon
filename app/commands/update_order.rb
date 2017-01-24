class UpdateOrder < Rectify::Command

  attr_reader :order, :params, :coupon_form

  def initialize(options)
    @order = options[:order]
    @params = options[:params]
    @coupon_form = options[:coupon_form]
  end

  def call
    set_coupon
    if coupon_valid? && order.update_attributes(order_params)
      broadcast :valid
    else
      broadcast :invalid
    end
  end

  private

  def order_params
    @params.require(:order).permit(order_items_attributes: [:id, :quantity])
  end

  def coupon_valid?
    return true if coupon_form.blank?
    coupon_form.valid?
  end

  def set_coupon
    if coupon_code.blank?
      order.coupon = nil
    else
      coupon = Coupon.find_by_code(coupon_code)
      order.coupon = coupon unless coupon.blank?
    end
  end

  def coupon_code
    params[:order][:coupon][:code]
  end

end
