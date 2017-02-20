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
      form_params = params[:"#{type}_attributes"]
      if use_base_address
        form_params = params[:"#{Address::BASE}_attributes"]
        form_params[:address_type] = type
      end
      address_by_params(form_params)
    end
  end

  def address_by_params(params)
    send("#{params[:address_type]}=", AddressForm.from_params(params))
  end

  def set_countries
    @countries = Country.select(:id, :name)
  end
end
