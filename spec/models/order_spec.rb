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
    it 'in_progress -> processing' do
      expect(subject).to transition_from(:in_progress).to(:processing).on_event(:confirm)
    end
    it 'processing -> shipping' do
      expect(subject).to transition_from(:processing).to(:shipping).on_event(:send_to_user)
    end
    it 'shipping -> delivered' do
      expect(subject).to transition_from(:shipping).to(:delivered).on_event(:deliver)
    end
    it 'processing -> cancel' do
      expect(subject).to transition_from(:processing).to(:canceled).on_event(:cancel)
    end
  end

end
