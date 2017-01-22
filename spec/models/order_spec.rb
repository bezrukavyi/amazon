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

end
