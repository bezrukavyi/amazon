require 'rails_helper'

RSpec.describe Address, type: :model do

  context 'enum address type' do
    let(:user) { create :user }
    it 'billing' do
      address = create :address, address_type: 0, addressable: user
      expect(address.address_type).to eq('billing')
    end
    it 'shipping' do
      address = create :address, address_type: 1, addressable: user
      expect(address.address_type).to eq('shipping')
    end
  end

end
