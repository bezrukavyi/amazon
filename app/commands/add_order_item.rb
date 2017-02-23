class AddOrderItem < Rectify::Command
  attr_reader :order, :book_id, :quantity

  def initialize(order, params)
    @order = order
    @book_id = params[:book_id]
    @quantity = params[:quantity].to_i
  end

  def call
    if order_item.try(:save) && order.save
      broadcast :valid, quantity
    else
      broadcast :invalid, item_errors
    end
  end

  private

  def order_item
    @order_item ||= order.add_item(book_id, quantity)
  end

  def item_errors
    order_item.decorate.all_errors if order_item.present?
  end
end
