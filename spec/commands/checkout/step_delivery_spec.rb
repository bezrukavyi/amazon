describe Checkout::StepDelivery do

  let(:order) { create :order, :with_items }
  let(:delivery) { create :delivery }

  describe '#call' do
    subject { Checkout::StepDelivery.new({ order: order, delivery_id: delivery.id }) }

    context 'valid' do
      it ':valid broadcast' do
        expect { subject.call }.to broadcast(:valid)
      end
      it 'update order' do
        expect { subject.call }.to change(order, :delivery).from(nil)
      end
    end

    it ':invalid broadcast' do
      allow(subject).to receive(:delivery_id).and_return(nil)
      expect { subject.call }.to broadcast(:invalid)
    end
  end
end
