class UpdateAddress < Rectify::Command
  attr_reader :addressable, :addresses

  def initialize(options)
    @addressable = options[:addressable]
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
      ["#{address[:address_type]}_attributes", address.to_h.except(:id)]
    end
    addressable.update_attributes(attributes.to_h)
  end
end
