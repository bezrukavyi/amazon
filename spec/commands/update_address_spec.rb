require 'rails_helper'

describe UpdateAddress do
  let(:user) { create :user }

  context 'When address exist' do
    let(:billing) { create :billing_address, addressable: user }
    let(:billing_form) { AddressForm.from_model(billing) }

    it 'update city' do
      old_city = billing_form.city
      billing_form.city = 'New city'
      expect { UpdateAddress.call(billing_form) }.to change { billing.reload.city }.from(old_city).to('New city')
    end

  end

  context 'When address not exist' do
    it 'create address' do
      params = attributes_for :billing_address, addressable_id: user.id, addressable_type: 'User'
      expect { UpdateAddress.call(params) }.to change { Address.count }.by(1)
    end

  end

end
