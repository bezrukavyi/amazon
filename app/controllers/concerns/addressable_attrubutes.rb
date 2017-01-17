module AddressableAttrubutes
  extend ActiveSupport::Concern

  included do
    attr_accessor(*Address.address_types.keys)
  end

  def set_addresses
    Address.address_types.keys.each do |type|
      send("#{type}=", AddressForm.from_model(current_user.send(type)))
    end
  end

  def set_countries
    @countries = Country.all
  end

end
