class OrderItemsController < ApplicationController

  def create
    order_item = current_order.add_item(params[:book_id], params[:quantity].to_i)
    if order_item.save
      flash[:notice] = "To cart successfully added #{params[:quantity]} books"
    else
      flash[:alert] = "Cant add this book, #{order_item.errors.full_messages.join(',')}"
    end
    redirect_back(fallback_location: book_path(params[:book_id]))
  end

end
