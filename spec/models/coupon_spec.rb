require 'rails_helper'

RSpec.describe Coupon, type: :model do

  subject { create(:coupon) }

  context 'validation' do
    it 'when validate' do
      expect(subject).to be_valid
    end
    context 'when invalid discount' do
      it 'less than 0' do
        subject.discount = -1
        expect(subject).not_to be_valid
      end
      it 'more than 100' do
        subject.discount = 101
        expect(subject).not_to be_valid
      end
    end
  end

  context 'association' do
    it 'belong to order' do
      expect(subject).to belong_to(:order)
    end
  end
end
