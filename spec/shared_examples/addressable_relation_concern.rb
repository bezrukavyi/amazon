shared_examples_for 'addressable_relation' do
  let(:resource) { create(described_class.name.underscore) }

  describe '#has_address' do
    it 'has one test' do
      resource.class.send('has_address', :test)
      expect(resource).to have_one(:test)
    end
  end

end
