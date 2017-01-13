shared_examples_for 'addressing' do
  let(:resource) { create(described_class.name.underscore) }

  describe '#has_address' do
    it 'has one test' do
      resource.class.send('has_address', :test)
      expect(resource).to respond_to(:test)
    end
    it 'redefine setter billing' do
      resource.class.send('has_address', :billing)
      address = create :shipping_address, addressable: resource
      expect { resource.billing = address }.to change { address.address_type }.from('shipping').to('billing')
    end
  end

end
