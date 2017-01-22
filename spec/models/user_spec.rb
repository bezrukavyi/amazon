require 'rails_helper'

RSpec.describe User, type: :model do

  subject { create :user }

  context 'validation' do
    it 'when validate' do
      expect(subject).to be_valid
    end
    it 'when invalid format of email' do
      subject.email = 'yaroslav555@gmail'
      expect(subject).not_to be_valid
    end
    it 'when invalid uniqueness email' do
      another_user = create :user
      user = build :user, email: another_user.email
      expect(user).not_to be_valid
    end
  end

  context 'association' do
    it 'has many providers' do
      expect(subject).to respond_to(:providers)
    end
    it 'has many orders' do
      expect(subject).to respond_to(:orders)
    end
  end

  context 'Concern Addressing' do
    it 'has one shipping' do
      expect(subject).to respond_to(:shipping)
    end
    it 'has one billing' do
      expect(subject).to respond_to(:billing)
    end
  end

  context 'Concern Addressing' do
    it_behaves_like 'addressable_relation'
  end

  describe '#order_in_processing' do
    it 'when order exist' do
      order = create :order, user: subject
      expect(subject.order_in_processing).to eq(order)
    end
    it 'when order not exist' do
      expect { subject.order_in_processing }.to change { Order.count }.by(1)
    end
  end

end
