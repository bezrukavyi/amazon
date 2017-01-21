require 'rails_helper'

RSpec.describe OrderItem, type: :model do

  let(:order) { create(:order) }
  subject { create(:order_item, order: order) }

  context 'validation' do
    it 'when validate' do
      expect(subject).to be_valid
    end
    it 'when invalid quantity' do
      subject.quantity = 0
      expect(subject).not_to be_valid
    end
  end

  context 'association' do
    it 'belong to books' do
      expect(subject).to belong_to(:book)
    end
    it 'belong to order' do
      expect(subject).to belong_to(:order)
    end
  end
end
