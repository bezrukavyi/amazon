module AddressableAttrubutes
  extend ActiveSupport::Concern

  included do
    attr_accessor(*Address::TYPES)
  end

  def set_addresses_by_model(current_object)
    Address::TYPES.each do |type|
      address = current_object.send(type)
      send("#{type}=", AddressForm.from_model(address))
    end
  end

  def set_addresses_by_params(params)
    Address::TYPES.map do |type|
      if params[:use_billing]
        form_params = params[:billing_attributes].merge(address_type: type)
      else
        form_params = params[:"#{type}_attributes"]
      end
      set_address_by_params(form_params)
    end
  end

  def set_address_by_params(params)
    send("#{params[:address_type]}=", AddressForm.from_params(params))
  end

  def set_countries
    @countries = Country.all
  end

end
