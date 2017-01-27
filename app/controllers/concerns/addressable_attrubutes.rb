module AddressableAttrubutes
  extend ActiveSupport::Concern

  included do
    attr_accessor(*Address::TYPES)
  end

  def set_addresses(current_object)
    Address::TYPES.each do |type|
      send("#{type}=", AddressForm.from_model(current_object.send(type)))
    end
  end

  def set_addresses_by_params(params, use_billing)
    Address::TYPES.map do |type|
      form_params = params[:"#{type}_attributes"]
      if use_billing && type != 'billing'
        form_params = params[:billing_attributes].merge(address_type: type)
      end
      set_address_by_params(form_params)
    end
  end

  def set_address_by_params(form_params)
    type = form_params[:address_type]
    send("#{type}=", AddressForm.from_params(form_params))
  end

  def all_addresses
    Address::TYPES.map { |type| send("#{type}") }
  end

  def set_countries
    @countries = Country.all
  end

end
