shared_examples_for 'addressable_attrubutes' do
  let(:resource) { controller }
  let(:user) { create :user, :full_package }

  context 'set addresses' do
    after do
      [:shipping, :billing].each do |type|
        expect(resource.send(type.to_s)).not_to be_nil
      end
    end

    it '#set_addresses_by_model' do
      [:shipping, :billing].each do |type|
        expect(AddressForm).to receive(:from_model).with(user.send(type.to_s)).and_return(double(type))
      end
      resource.send('set_addresses_by_model', user)
    end

    it '#set_addresses_by_params' do
      params = { billing_attributes: attributes_for(:address_order, :billing),
                 shipping_attributes: attributes_for(:address_order, :shipping) }
      [:shipping, :billing].each do |type|
        expect(AddressForm).to receive(:from_params).with(params["#{type}_attributes".to_sym]).and_return(double(type))
      end
      resource.send('set_addresses_by_params', params)
    end
  end
end
