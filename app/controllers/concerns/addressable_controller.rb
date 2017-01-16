module AddressableController
  extend ActiveSupport::Concern

  included do
    before_action :set_countries, only: [:edit, :update]
    attr_accessor(*Address.address_types.keys)
  end

  def address_update
    @address = AddressForm.from_params(params)
    if @address.valid?
      UpdateAddress.call(@address) do
        on(:valid) { redirect_back fallback_location: root_path, notice: t('devise.registrations.updated') }
        on(:invalid) { render :edit }
      end
    else
      set_address(@address.address_type, @address)
      render :edit
    end
  end

  def set_addresses
    Address.address_types.keys.each do |type|
      send("#{type}=", AddressForm.from_model(current_user.send(type)))
    end
  end

  def set_address(type, address_form)
    send("#{type}=", address_form)
  end

  def set_countries
    @countries = Country.all
  end

end
