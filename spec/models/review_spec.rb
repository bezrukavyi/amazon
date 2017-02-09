describe Review, type: :model do

  subject { build :review }

  context 'associations' do
    it { should belong_to(:book) }
    it { should belong_to(:user) }
  end

  context 'aasm state' do
    it 'unprocessed -> approved' do
      expect(subject).to transition_from(:unprocessed).to(:approved).on_event(:approve)
    end
    it 'unprocessed -> rejecte' do
      expect(subject).to transition_from(:unprocessed).to(:rejected).on_event(:reject)
    end
  end

end
