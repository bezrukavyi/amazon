module Addressable
  extend ActiveSupport::Concern

  included do
    attr_accessor(*Address.address_types.keys)
  end

  def address_update
    @address = AddressForm.from_params(params)
    if @address.valid?
      UpdateAddress.call(@address) do
        on(:valid) { redirect_to user_edit_path, notice: t('.success_updated_email') }
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


end
