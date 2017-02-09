describe UpdateAddress do

  let(:addressable) { create :order }

  context 'valid' do
    let(:address) { AddressForm.from_params(attributes_for(:address_order, :billing)) }
    let(:another_address) { AddressForm.from_params(attributes_for(:address_order, :shipping)) }
    subject { UpdateAddress.new({ addressable: addressable, addresses: [address] }) }

    it 'set broadcast' do
      expect { subject.call }.to broadcast(:valid)
    end
    it 'update addressable shipping' do
      expect { subject.call }.to change(addressable, :billing)
    end
    it 'create new address' do
      expect { subject.call }.to change { Address.count }.by(1)
    end
    it 'create new addresses' do
      subject = UpdateAddress.new({ addressable: addressable, addresses: [address, another_address] })
      expect { subject.call }.to change { Address.count }.by(2)
    end

  end

  context 'invalid' do
    let(:address) { AddressForm.from_params(attributes_for(:address_order, :invalid)) }
    subject { UpdateAddress.new({ addressable: addressable, addresses: [address] }) }

    it 'set broadcast' do
      expect { subject.call }.to broadcast(:invalid)
    end
    it 'dont update addressable' do
      expect { subject.call }.not_to change(addressable, :shipping)
    end
    it 'dont create new address' do
      expect { subject.call }.not_to change { Address.count }
    end
  end

end
