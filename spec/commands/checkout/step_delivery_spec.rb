require 'rails_helper'

describe CheckoutDelivery do
  let(:order) { create :order }

  context '#call' do
    subject { CheckoutDelivery.new(order, {}) }

    it 'valid' do
      params = { delivery_id: create(:delivery).id }
      allow(subject).to receive(:allowed_params).and_return(params)
      expect { subject.call }.to broadcast(:valid)
    end
    it 'invalid' do
      params = { delivery_id: nil }
      allow(subject).to receive(:allowed_params).and_return(params)
      expect { subject.call }.to broadcast(:invalid)
    end
  end
end
