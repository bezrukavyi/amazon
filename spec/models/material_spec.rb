describe Material, type: :model do

  subject { build :material }

  context 'association' do
    it { expect(subject).to have_and_belong_to_many(:books) }
  end

  context 'validation' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_length_of(:name).is_at_most(100) }
  end

  context 'before save' do
    it '#downcase_name' do
      subject.name = 'Rspec'
      subject.save
      expect(subject.reload.name).to eq('rspec')
    end
  end

end
