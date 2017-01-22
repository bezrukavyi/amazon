class CartsController < ApplicationController

  def edit
    @coupon_form = CouponForm.from_model(current_order.coupon)
  end

  def update
    @coupon_form = CouponForm.from_params(coupon_params)
    if @coupon_form.valid?
      UpdateOrder.call(current_order, params) do
        on(:valid) { redirect_to cart_path, notice: 'Order successfully updated' }
        on(:invalid) { render :edit }
      end
    else
      render :edit
    end
  end

  def coupon_params
    params[:order][:coupon].merge({ order_id: current_order.id })
  end

end
