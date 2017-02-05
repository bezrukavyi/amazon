require 'rails_helper'

describe UpdateOrder do

  let(:order) { create :order, :with_items }
  let(:order_item) { order.order_items.first }
  let(:coupon) { create :coupon }

  subject { UpdateOrder.new({ order: order }) }

  before do
    allow(subject).to receive(:coupon).and_return(coupon)
  end

  context 'update order items' do
    let(:order_params) { { order_items_attributes: { id: order_item.id, quantity: 20 } } }
    let(:invalid_order_params) { { order_items_attributes: { id: order_item.id, quantity: -100 } } }

    context 'valid' do
      before do
        allow(subject).to receive(:order_params).and_return(order_params)
      end
      it 'set valid broadcast' do
        expect { subject.call }.to broadcast(:valid)
      end
      it 'change order items' do
        expect { subject.call }.to change { order_item.reload.quantity }.from(1).to(20)
      end
    end

    it 'invalid' do
      allow(subject).to receive(:order_params).and_return(invalid_order_params)
      expect { subject.call }.to broadcast(:invalid)
    end
  end

  context 'update coupon' do
    before do
      allow(subject).to receive(:order_params).and_return({})
    end
    it 'set new coupon' do
      expect { subject.call }.to change{ order.reload.coupon }.from(nil).to(coupon)
    end
  end

end
