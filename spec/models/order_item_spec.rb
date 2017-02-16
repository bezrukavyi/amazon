describe OrderItem, type: :model do
  subject { build :order_item }

  context 'association' do
    it { expect(subject).to belong_to(:book) }
    it { expect(subject).to belong_to(:order) }
  end

  context 'validation' do
    it do
      should validate_numericality_of(:quantity).is_greater_than_or_equal_to(0)
    end
    it do
      should validate_numericality_of(:quantity).is_less_than_or_equal_to(99)
    end

    describe '#stock_validate' do
      it 'invalid' do
        subject.book.count = 5
        subject.quantity = 6
        subject.valid?
        expect(subject.errors.full_messages).to include('Quantity ' +
          I18n.t('validators.order_item.stock'))
      end
      it 'valid' do
        subject.book.count = 5
        subject.quantity = 4
        expect(subject).to be_valid
      end
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
