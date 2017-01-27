require 'rails_helper'

describe Checkout::StepPayment do

  let(:order) { create :order }

  context 'valid' do
    let(:credit_card) { CreditCardForm.from_params(attributes_for(:credit_card)) }
    subject { Checkout::StepPayment.new({ order: order, payment_form: credit_card }) }

    it 'set broadcast' do
      expect { subject.call }.to broadcast(:valid)
    end

    context 'when credit exit' do
      before do
        @credit_card = create :credit_card
      end
      let(:payment_form) { CreditCardForm.from_model(@credit_card) }
      subject { Checkout::StepPayment.new({ order: order, payment_form: payment_form }) }

      it 'set credit_card to order' do
        expect { subject.call }.to change(order, :credit_card)
      end
      it 'not create new credit card' do
        expect { subject.call }.not_to change { CreditCard.count }
      end
    end

    context 'when credit not exit' do
      it 'set credit_card to order' do
        expect { subject.call }.to change(order, :credit_card)
      end
      it 'not create new credit card' do
        expect { subject.call }.to change { CreditCard.count }.by(1)
      end
    end

  end

  context 'invalid' do
    let(:credit_card) { CreditCardForm.from_params(attributes_for(:credit_card, :invalid)) }
    subject { Checkout::StepPayment.new({ order: order, payment_form: credit_card }) }

    it 'set broadcast' do
      expect { subject.call }.to broadcast(:invalid)
    end
    it 'dont update order' do
      expect { subject.call }.not_to change(order, :credit_card)
    end
    it 'dont create new credit_card' do
      expect { subject.call }.not_to change { CreditCard.count }
    end
  end
end
