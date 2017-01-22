require 'rails_helper'

RSpec.describe Order, type: :model do

  subject { create :order }

  context 'association' do
    it 'belongs_to user' do
      expect(subject).to belong_to(:user)
    end
    it 'belongs_to credit_card' do
      expect(subject).to belong_to(:credit_card)
    end
  end

  context 'Concern Addressing' do
    it_behaves_like 'addressable_relation'
  end

  context 'aasm state' do
    it 'processing -> in_progress' do
      expect(subject).to transition_from(:processing).to(:in_progress).on_event(:confirm)
    end
    it 'in_progress -> in_delivery' do
      expect(subject).to transition_from(:in_progress).to(:in_delivery).on_event(:send_to_user)
    end
    it 'in_delivery -> delivered' do
      expect(subject).to transition_from(:in_delivery).to(:delivered).on_event(:deliver)
    end
    it 'in_progress -> cancel' do
      expect(subject).to transition_from(:in_progress).to(:canceled).on_event(:cancel)
    end
  end

  describe '#add_item' do
    it 'when order item exist' do
      order_item = create :order_item, order: subject
      expect { subject.add_item(order_item.book.id, 20).save }
        .to change { order_item.reload.quantity }.by(20)
    end
    it 'when order item not exist' do
      book = create :book
      expect { subject.add_item(book.id).save }
        .to change { OrderItem.count }.by(1)
    end
  end

  it '#sub_total' do
    item_first = create :order_item, order: subject
    item_second = create :order_item, order: subject
    expect(subject.sub_total).to eq([item_first.sub_total, item_second.sub_total].sum)
  end

  it '#coupon_cost' do
    subject.coupon = create :coupon, discount: 50
    allow(subject).to receive(:sub_total).and_return(100)
    expect(subject.coupon_cost).to eq(-50.0)
  end

  describe '#calc_total_cost' do
    it 'without coupon' do
      expect(subject.calc_total_cost).to eq(subject.sub_total)
    end
    it 'with coupon' do
      allow(subject).to receive(:sub_total).and_return(30)
      allow(subject).to receive(:coupon_cost).and_return(-20)
      expect(subject.calc_total_cost(:coupon)).to eq(10)
    end
    it 'with coupon and delivery' do
      allow(subject).to receive(:sub_total).and_return(10)
      allow(subject).to receive(:coupon_cost).and_return(-20)
      allow(subject).to receive(:delivery_cost).and_return(20)
      expect(subject.calc_total_cost(:coupon, :delivery)).to eq(10)
    end
  end

end
