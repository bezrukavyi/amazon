class OrderItemsController < ApplicationController

  def create
    book_id, quantity = params[:book_id], params[:quantity].to_i
    order_item = current_order.add_item(book_id, quantity)
    if order_item.try(:save) && current_order.save
      flash[:notice] = t('flash.success.book_add', count: quantity)
    else
      errors = order_item&.decorate&.all_errors
      flash[:alert] = t('flash.failure.book_add', errors: errors)
    end
    redirect_back(fallback_location: book_path(book_id))
  end

  def destroy
    order_item = OrderItem.find(params[:id])
    if order_item.destroy && current_order.save
      flash[:notice] = t('flash.success.book_destroy', title: order_item.book.title)
    else
      flash[:alert] = t('flash.failure.book_destroy', errors: order_item.decorate.all_errors)
    end
    redirect_back(fallback_location: edit_cart_path)
  end

end
