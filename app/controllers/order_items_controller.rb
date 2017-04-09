class OrderItemsController < ApplicationController
  def create
    AddOrderItem.call(current_order, params) do
      on(:valid) do |quantity|
        flash[:notice] = t('flash.success.book_add', count: quantity)
      end
      on(:invalid) do |errors|
        flash[:alert] = t('flash.failure.book_add', errors: errors)
      end
    end
    redirect_back(fallback_location: root_path)
  end

  def destroy
    order_item = OrderItem.find(params[:id])
    if order_item.destroy && current_order.save
      flash[:notice] = t('flash.success.book_destroy',
                         title: order_item.book.title)
    else
      flash[:alert] = t('flash.failure.book_destroy',
                        errors: order_item.decorate.all_errors)
    end
    redirect_back(fallback_location: edit_cart_path)
  end
end
