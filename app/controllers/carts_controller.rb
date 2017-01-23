class CartsController < ApplicationController

  def edit
    @coupon_form = CouponForm.from_model(current_order.coupon)
  end

  def update
    @coupon_form = CouponForm.from_params(params[:order][:coupon])
    options = { order: current_order, params: params, coupon_form: @coupon_form }
    UpdateOrder.call(options) do
      on(:valid) { redirect_to cart_path, notice: t('carts.edit.success_updated') }
      on(:invalid) { failed_update }
    end
  end

  private
  def failed_update
    flash[:alert] = t('carts.edit.failed_updated')
    render :edit
  end

end
