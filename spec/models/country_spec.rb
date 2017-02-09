describe Country, type: :model do

  context 'validation' do
    it { should validate_presence_of(:name) }
  end

  context 'association' do
    it { should have_many(:deliveries) }
  end

end
