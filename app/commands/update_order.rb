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
    return true if coupon_form.blank? || ( coupon.present? && coupon == order.coupon )
    coupon_form.present? ? coupon_form.valid? : true
  end

  def coupon
    coupon = Coupon.find_by_code(params[:order][:coupon][:code])
  end

end
