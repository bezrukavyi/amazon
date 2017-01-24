require 'rails_helper'

RSpec.describe Address, type: :model do

  subject { build :address_user, :billing }

  context 'associations' do
    it { should belong_to(:addressable) }
    it { should belong_to(:country) }
  end

  context 'enum address type' do
    it 'billing' do
      address = build :address_user, :billing
      expect(address.address_type).to eq('billing')
    end
    it 'shipping' do
      address = build :address_user, :shipping
      expect(address.address_type).to eq('shipping')
    end
  end

end
