module AddressableAttrubutes
  extend ActiveSupport::Concern

  included do
    attr_accessor(*Address::TYPES)
  end

  def addresses_by_model(current_object)
    Address::TYPES.each do |type|
      address = current_object.send(type)
      send("#{type}=", AddressForm.from_model(address))
    end
  end

  def addresses_by_params(params, use_base_address = false)
    Address::TYPES.map do |type|
      base_type = use_base_address ? Address::BASE : type
      form_params = params[:"#{base_type}_attributes"]
      form_params = form_params.merge(address_type: type) if use_base_address
      address_by_params(form_params)
    end
  end

  def address_by_params(params)
    send("#{params[:address_type]}=", AddressForm.from_params(params))
  end

  def set_countries
    @countries = Country.all
  end
end
