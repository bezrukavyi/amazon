class OrderItemsController < ApplicationController

  def create
    book_id, quantity = params[:book_id], params[:quantity].to_i
    order_item = current_order.add_item(book_id, quantity)
    if order_item.save && current_order.save
      flash[:notice] = t('books.success_add', count: quantity)
    else
      flash[:alert] = t('books.failed_add', error: order_item.decorate.all_errors)
    end
    redirect_back(fallback_location: book_path(book_id))
  end

  def destroy
    @order_item = OrderItem.find(params[:id])
    if @order_item.destroy && current_order.save
      flash[:notice] = t('books.success_destroy', title: @order_item.book.title)
    else
      binding.pry
      flash[:alert] = "#{@order_item.errors.full_messages}"
    end
    redirect_back(fallback_location: edit_cart_path)
  end

end
