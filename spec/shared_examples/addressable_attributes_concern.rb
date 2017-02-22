shared_examples_for 'addressable_attrubutes' do
  let(:resource) { controller }
  let(:user) { create :user, :full_package }

  context 'set addresses' do
    it '#addresses_by_model' do
      result = double(:billing)
      allow(AddressForm).to receive_message_chain(:from_model, :merge_info)
        .with(user.send(:billing)).with(user).and_return(result)
      resource.send('addresses_by_model', user)
      expect(resource.send(:billing)).to eq(result)
    end

    it '#addresses_by_params' do
      params = {
        billing_attributes: attributes_for(:address_order, :billing),
        shipping_attributes: attributes_for(:address_order, :shipping)
      }
      %i(shipping billing).each do |type|
        expect(AddressForm).to receive(:from_params)
          .with(params["#{type}_attributes".to_sym]).and_return(double(type))
      end
      resource.send('addresses_by_params', params)
    end
  end
end
