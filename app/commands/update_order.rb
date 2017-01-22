class UpdateOrder < Rectify::Command

  attr_reader :order, :params

  def initialize(order, params)
    @order = order
    @params = params
  end

  def call
    set_coupon
    if order.update_attributes(order_params)
      broadcast :valid
    else
      broadcast :invalid
    end
  end

  private

  def order_params
    @params.require(:order).permit(order_items_attributes: [:id, :quantity])
  end

  def coupon_code
    @params[:order][:coupon][:code]
  end

  def set_coupon
    if coupon_code.blank?
      order.coupon = nil
    else
      coupon = Coupon.find_by_code(coupon_code)
      order.coupon = coupon unless coupon.blank?
    end
  end

end
