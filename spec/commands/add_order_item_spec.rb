describe AddOrderItem do
  let(:order) { create :order, :with_items }
  let(:item) { order.order_items.first }
  let(:book_id) { item.book.id }
  let(:params) { { book_id: book_id, quantity: 20 } }

  context '#call' do
    subject { AddOrderItem.new(order, params) }
    context 'valid' do
      it 'set valid broadcast' do
        expect { subject.call }.to broadcast(:valid)
      end
      it 'set processing state' do
        expect { subject.call }.to change { item.reload.quantity }
      end
    end

    it 'invalid' do
      invalid_params = { book_id: book_id, quantity: 1000 }
      subject = AddOrderItem.new(order, invalid_params)
      expect { subject.call }.to broadcast(:invalid)
    end
  end
end
