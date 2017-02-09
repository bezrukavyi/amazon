describe Checkout::AccessStep do

  let(:user) { create :user, :full_package }

  describe '#call' do

    context 'When allow' do
      let(:order) { create :order, :with_items, user: user }

      it ':address step' do
        subject = Checkout::AccessStep.new(order, user, :address)
        expect{ subject.call }.to broadcast(:allow)
      end

      it ':delivery step' do
        order.shipping = user.shipping
        order.billing = user.billing
        subject = Checkout::AccessStep.new(order, user, :delivery)
        expect{ subject.call }.to broadcast(:allow)
      end

      it ':payment step' do
        order.shipping = user.shipping
        order.billing = user.billing
        order.delivery = create :delivery
        subject = Checkout::AccessStep.new(order, user, :payment)
        expect{ subject.call }.to broadcast(:allow)
      end

      it ':confirm step' do
        order.shipping = user.shipping
        order.billing = user.billing
        order.delivery = create :delivery
        order.credit_card = user.credit_cards.first
        subject = Checkout::AccessStep.new(order, user, :confirm)
        expect{ subject.call }.to broadcast(:allow)
      end

      it ':complete step' do
        order.shipping = user.shipping
        order.billing = user.billing
        order.delivery = create :delivery
        order.credit_card = user.credit_cards.first
        order.confirm
        subject = Checkout::AccessStep.new(order, user, :complete)
        expect{ subject.call }.to broadcast(:allow)
      end
    end

    context 'When empty_cart' do
      let(:order) { create :order, user: user }

      it ':delivery step' do
        subject = Checkout::AccessStep.new(order, user, :delivery)
        expect{ subject.call }.to broadcast(:empty_cart)
      end

      it ':payment step' do
        subject = Checkout::AccessStep.new(order, user, :payment)
        expect{ subject.call }.to broadcast(:empty_cart)
      end

      it ':confirm step' do
        subject = Checkout::AccessStep.new(order, user, :confirm)
        expect{ subject.call }.to broadcast(:empty_cart)
      end

      it ':complete step' do
        subject = Checkout::AccessStep.new(order, user, :complete)
        expect{ subject.call }.to broadcast(:allow)
      end
    end

  end
end
