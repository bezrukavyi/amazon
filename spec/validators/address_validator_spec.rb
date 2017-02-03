require 'rails_helper'

RSpec.describe AddressValidator, type: :validator do

  let(:addressable) { create :user }
  let(:shipping) { AddressForm.from_params(attributes_for(:address_user, :shipping,
    addressable_id: addressable.id, addressable_type: 'User')) }

  describe '#name' do

    context 'valid' do
      after do
        shipping.validate(:name)
        expect(shipping.errors.full_messages).to be_blank
      end

      it 'with -' do
        shipping.name = '343-2342'
      end
      it 'without ,' do
        shipping.name = '234, 234'
      end
      it 'with space' do
        shipping.name = '234 23423'
      end
    end

    it 'invalid by unsupport symbol' do
      shipping.name = 'sdasd#sd'
      shipping.validate(:name)
      expect(shipping.errors.full_messages).to include('Name ' + I18n.t('validators.address.name'))
    end

  end

  describe '#zip' do
    it 'valid with -' do
      shipping.zip = '234-234'
      shipping.validate(:zip)
      expect(shipping.errors.full_messages).to be_blank
    end
    it 'invalid with ,' do
      shipping.zip = '234,234'
      shipping.validate(:zip)
      expect(shipping.errors.full_messages).to include('Zip ' + I18n.t('validators.address.zip'))
    end
  end

end
