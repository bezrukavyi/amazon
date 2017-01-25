module AddressableAttrubutes
  extend ActiveSupport::Concern

  included do
    attr_accessor(*Address.address_types.keys)
  end

  def set_addresses(current_object)
    Address.address_types.keys.each do |type|
      send("#{type}=", AddressForm.from_model(current_object.send(type)))
    end
  end

  def set_addresses_by_params(object_params)
    Address.address_types.keys.each do |type|
      send("#{type}=", AddressForm.from_params(object_params[:"#{type}_attributes"]))
    end
  end

  def all_addresses
    Address.address_types.keys.map { |type| send("#{type}") }
  end

  def set_countries
    @countries = Country.all
  end

end
