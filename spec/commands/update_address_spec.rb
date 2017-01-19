require 'rails_helper'

describe UpdateAddress do
  let(:addressable) { create :user }

  let(:address_form) { AddressForm.from_params(attributes_for(:shipping_address,
    addressable_id: addressable.id, addressable_type: 'User')) }

  context '#call' do
    subject { UpdateAddress.new(address_form) }

    context 'valid' do
      before do
        allow(subject.address_form).to receive(:valid?).and_return(true)
      end
      it 'set valid broadcast' do
        expect { subject.call }.to broadcast(:valid)
      end
      it 'set processing state' do
        expect { subject.call }.to change{ Address.count }.by(1)
      end
    end

    it 'invalid' do
      allow(subject.address_form).to receive(:valid?).and_return(false)
      expect { subject.call }.to broadcast(:invalid)
    end
  end
end
