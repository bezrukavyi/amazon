describe OrderItem, type: :model do
  subject { build :order_item }
  let(:order) { order_item.order }

  context 'association' do
    it { expect(subject).to belong_to(:book) }
    it { expect(subject).to belong_to(:order) }
  end

  context 'validation' do
    it { should validate_numericality_of(:quantity).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:quantity).is_less_than_or_equal_to(99) }

    it '#stock_validate' do
      subject.book.count = 5
      subject.quantity = 6
      expect(subject).not_to be_valid
    end
  end

  it '#sub_total' do
    subject.book = create :book, price: 10
    subject.quantity = 2
    expect(subject.sub_total).to eq(20)
  end

  context 'Before validation' do
    it '#destroy_if_empty' do
      item = create :order_item
      item.quantity = 0
      expect { item.valid? }.to change { OrderItem.count }.by(-1)
    end
  end
end
