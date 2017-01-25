class CheckoutAddress < Rectify::Command

  attr_reader :order, :addresses

  def initialize(options)
    @order = options[:order]
    @params = options[:params]
    @addresses = options[:addresses]
  end

  def call
    if attributes_valid? && update_order
      broadcast(:valid)
    else
      broadcast(:invalid)
    end
  end

  private

  def attributes_valid?
    addresses.map(&:valid?).all? { |validation| validation == true }
  end

  def update_order
    attributes = addresses.map do |address|
      ["#{address[:address_type]}_attributes", address.to_h]
    end.to_h
    current_order.update_attributes(attributes)
  end

end
