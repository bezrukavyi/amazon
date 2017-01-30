require 'rails_helper'

RSpec.describe User, type: :model do

  subject { create :user }

  context 'associations' do
    [:providers, :reviews, :orders, :credit_card].each do |model_name|
      it { should have_many(model_name) }
    end
  end

  context 'validation' do
    it { should validate_length_of(:first_name).is_at_most(50) }
    it { should validate_length_of(:last_name).is_at_most(50) }
    it { should validate_length_of(:email).is_at_most(63) }
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
