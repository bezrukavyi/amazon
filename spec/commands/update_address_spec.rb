require 'rails_helper'

describe UpdateAddress do

  let(:user) { create :user }

  context 'valid' do
    let(:address) { AddressForm.from_params(attributes_for(:address_user, :shipping)) }
    subject { UpdateAddress.new({ addressable: user, addresses: [address] }) }

    it 'set broadcast' do
      expect { subject.call }.to broadcast(:valid)
    end
    it 'update user shipping' do
      expect { subject.call }.to change(user, :shipping)
    end
    it 'create new address' do
      expect { subject.call }.to change { Address.count }.by(1)
    end
  end

  context 'invalid' do
    let(:address) { AddressForm.from_params(attributes_for(:address_user, :invalid)) }
    subject { UpdateAddress.new({ addressable: user, addresses: [address] }) }

    it 'set broadcast' do
      expect { subject.call }.to broadcast(:invalid)
    end
    it 'dont update user' do
      expect { subject.call }.not_to change(user, :shipping)
    end
    it 'dont create new address' do
      expect { subject.call }.not_to change { Address.count }
    end
  end

end
