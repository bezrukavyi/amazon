describe CreditCard, type: :model do
  subject { build :credit_card }

  context 'association' do
    it { should belong_to :user }
    it { should have_many(:orders) }
  end
end
