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

  def set_countries
    @countries = Country.all
  end

  def addresses_forms(current_object)
    class_name = current_object.class.name
    addresses_params(class_name).map do |address_params|
      send("#{address_params[:address_type]}=", AddressForm.from_params(address_params,
        addressable_id: current_object.id, addressable_type: current_object.class.name))
    end
  end

  private

  def addresses_params(class_name)
    Address.address_types.keys.map do |type|
      params[class_name.downcase]["#{type}_attributes"]
    end
  end

end
