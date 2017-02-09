describe Checkout::StepConfirm do

  let(:order) { create :order, :checkout_package, user: nil }
  let(:user) { create :user }

  context 'valid' do
    subject { Checkout::StepConfirm.new({ order: order, user: user, confirm: true }) }

    it 'set broadcast' do
      expect { subject.call }.to broadcast(:valid)
    end

    it 'change order state' do
      expect { subject.call }.to change(order, :state).from('processing').to('in_progress')
    end

    it 'send letter' do
      expect { subject.call }.to change { ActionMailer::Base.deliveries.count }.by(1)
    end

  end

  context 'invalid' do
    subject { Checkout::StepConfirm.new({ order: order, user: user, confirm: '' }) }

    it 'set broadcast' do
      expect { subject.call }.to broadcast(:invalid)
    end

    it 'change order state' do
      expect { subject.call }.not_to change(order, :state)
    end

  end
end
