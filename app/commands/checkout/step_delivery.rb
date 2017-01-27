class Checkout::StepDelivery < Rectify::Command

  attr_reader :order, :delivery_id

  def initialize(options)
    @order = options[:order]
    @delivery_id = options[:delivery_id]
  end

  def call
    if delivery_id_valid? && order_update
      broadcast :valid
    else
      broadcast :invalid
    end
  end

  private

  def delivery_id_valid?
    Delivery.exists?(id: delivery_id)
  end

  def order_update
    order.update_attributes(delivery_id: delivery_id)
  end

end
