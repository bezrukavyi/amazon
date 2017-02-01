class CartsController < ApplicationController

  def edit
    @coupon_form = CouponForm.from_model(current_order.coupon)
  end

  def update
    @coupon_form = CouponForm.from_params(params[:order][:coupon])
    options = { order: current_order, params: params, coupon_form: @coupon_form }
    UpdateOrder.call(options) do
      on(:valid) { redirect_to edit_cart_path, notice: t('flash.success.cart_update') }
      on(:invalid) { flash_render :edit, alert: t('flash.failure.cart_update') }
    end
  end

  private

  def current_order
    @current_order ||= super && Order.with_items_book.find(@current_order.id)
  end

end
