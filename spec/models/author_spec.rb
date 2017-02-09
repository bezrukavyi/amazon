describe Author, type: :model do
  subject { build :author }

  context 'association' do
    it { should have_and_belong_to_many(:books) }
    it { should have_many(:categories) }
  end

  context 'validation' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }

    context 'nested uniqueness' do
      it 'valid' do
        author = create :author
        expect(build :author, first_name: author.first_name,
          last_name: 'Another name').to be_valid
      end
      it 'invalid' do
        author = create :author
        expect(build :author, first_name: author.first_name,
          last_name: author.last_name).not_to be_valid
      end
    end
  end

end
