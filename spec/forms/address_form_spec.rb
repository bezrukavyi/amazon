require 'rails_helper'

RSpec.describe AddressForm, :address_form do
  let(:addressable) { create :user }

  subject { AddressForm.from_params(attributes_for(:shipping_address,
    addressable_id: addressable.id, addressable_type: addressable.class)) }

  context 'valid' do
    it 'valid object' do
      is_expected.to be_valid
    end
    it '#wrong_code' do
      country = create :country, code: '280'
      subject.country_id = country.id
      subject.phone = '+280632863823'
      is_expected.to be_valid
    end
  end

  context 'invalid phone' do
    it 'length' do
      subject.phone = '+380632863482334234'
      is_expected.not_to be_valid
    end
    it 'format' do
      subject.phone = '+380632A63823'
      is_expected.not_to be_valid
    end
    it '#wrong_code' do
      country = create :country, code: '280'
      subject.country_id = country.id
      subject.phone = '+380632863823'
      is_expected.not_to be_valid
    end
  end

  it 'invalid country' do
    subject.country_id = nil
    is_expected.not_to be_valid
  end

end
