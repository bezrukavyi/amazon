shared_examples_for 'addressable_relation' do
  let(:resource) { create(described_class.name.underscore) }

  describe '#has_address' do
    it 'has one test' do
      resource.class.send('has_address', :test)
      expect(resource).to have_one(:test)
    end
    it 'redefine setter billing' do
      resource.class.send('has_address', :shipping)
      address = build :address_user, :shipping, addressable: resource
      expect { resource.billing = address }.to change { address.address_type }.from('shipping').to('billing')
    end
  end

end
