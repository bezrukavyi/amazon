describe Checkout::StepPayment do
  let(:order) { create :order }

  context 'valid' do
    let(:params) do
      { order: { credit_card_attributes: attributes_for(:credit_card) } }
    end

    context 'when credit not exit' do
      let(:credit_card) do
        CreditCardForm.from_params(params[:order][:credit_card_attributes])
      end
      subject { Checkout::StepPayment.new(order: order, params: params) }
      before do
        expect(CreditCardForm).to receive(:from_params)
          .with(params[:order][:credit_card_attributes])
          .and_return(credit_card)
      end

      it 'set credit_card to order' do
        expect { subject.call }.to change(order, :credit_card)
      end
      it 'not create new credit card' do
        expect { subject.call }.to change { CreditCard.count }.by(1)
      end
      it 'set broadcast' do
        expect { subject.call }.to broadcast(:valid)
      end
    end

    context 'when credit exit' do
      before { @credit_card = create :credit_card }
      let(:payment_form) { CreditCardForm.from_model(@credit_card) }

      before do
        allow_any_instance_of(Checkout::StepPayment).to receive(:payment_form)
          .and_return(payment_form)
      end

      subject do
        Checkout::StepPayment.new(order: order, params: params)
      end

      it 'set credit_card to order' do
        expect { subject.call }.to change(order, :credit_card)
      end
      it 'not create new credit card' do
        expect { subject.call }.not_to change { CreditCard.count }
      end
      it 'update credit card' do
        payment_form.name = 'Rspec Rspec'
        expect { subject.call }.to change { @credit_card.reload.name }
      end
      it 'set broadcast' do
        expect { subject.call }.to broadcast(:valid)
      end
    end
  end
end
