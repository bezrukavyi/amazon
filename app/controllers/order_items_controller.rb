class OrderItemsController < ApplicationController

  def create
    order_item = current_order.add_item(params[:book_id], params[:quantity].to_i)
    if order_item.save
      flash[:notice] = t('books.success_add', count: params[:quantity].to_i)
    else
      flash[:alert] = t('books.failed_add',
        error: order_item.errors.full_messages.join('. '))
    end
    redirect_back(fallback_location: book_path(params[:book_id]))
  end

  def destroy
    @order_item = OrderItem.find(params[:id])
    if @order_item.destroy
      flash[:notice] = t('books.success_destroy', title: @order_item.book.title)
    else
      flash[:alert] = "#{@order_item.errors.full_messages}"
    end
    redirect_back(fallback_location: cart_path)
  end

end
