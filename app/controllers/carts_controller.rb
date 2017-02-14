class CartsController < ApplicationController
  include Rectify::ControllerHelpers

  def edit
    @coupon_form = CouponForm.from_model(current_order.coupon)
  end

  def update
    UpdateOrder.call(current_order, params) do
      on(:valid) do
        redirect_to edit_cart_path, notice: t('flash.success.cart_update')
      end
      on(:invalid) do |coupon_form|
        expose coupon_form: coupon_form
        flash_render :edit, alert: t('flash.failure.cart_update')
      end
    end
  end

  private

  def current_order
    @current_order ||= super && Order.with_items_book.find(@current_order.id)
  end
end
