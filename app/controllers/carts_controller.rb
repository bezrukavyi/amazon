class CartsController < ApplicationController

  def edit
    @coupon_form = CouponForm.from_model(current_order.coupon)
  end

  def update
    @coupon_form = CouponForm.from_params(params[:order][:coupon])
    options = { order: current_order, params: params, coupon_form: @coupon_form }
    UpdateOrder.call(options) do
      on(:valid) { redirect_to cart_path, notice: 'Order successfully updated' }
      on(:invalid) { render :edit }
    end
  end

end
