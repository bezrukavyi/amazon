require 'rails_helper'

describe Checkout::AccessStep do

  let(:user) { create :user, :full_package }

  describe '#allow?' do

    context 'When allow' do
      let(:order) { create :order, user: user }

      it ':address step' do
        subject = Checkout::AccessStep.new(order, :address)
        expect(subject.allow?).to be_truthy
      end

      it ':delivery step' do
        order.shipping = user.shipping
        order.billing = user.billing
        subject = Checkout::AccessStep.new(order, :delivery)
        expect(subject.allow?).to be_truthy
      end

      it ':payment step' do
        order.shipping = user.shipping
        order.billing = user.billing
        order.delivery = create :delivery
        subject = Checkout::AccessStep.new(order, :payment)
        expect(subject.allow?).to be_truthy
      end

      it ':confirm step' do
        order.shipping = user.shipping
        order.billing = user.billing
        order.delivery = create :delivery
        order.credit_card = user.credit_card
        subject = Checkout::AccessStep.new(order, :confirm)
        expect(subject.allow?).to be_truthy
      end

      it ':complete step' do
        order.shipping = user.shipping
        order.billing = user.billing
        order.delivery = create :delivery
        order.credit_card = user.credit_card
        order.confirm
        subject = Checkout::AccessStep.new(order, :complete)
        expect(subject.allow?).to be_truthy
      end
    end

    context 'When not allow' do
      let(:order) { create :order, user: user }

      it ':delivery step' do
        subject = Checkout::AccessStep.new(order, :delivery)
        expect(subject.allow?).to be_falsey
      end

      it ':payment step' do
        order.delivery = create :delivery
        subject = Checkout::AccessStep.new(order, :payment)
        expect(subject.allow?).to be_falsey
      end

      it ':confirm step' do
        order.shipping = user.shipping
        order.billing = user.billing
        subject = Checkout::AccessStep.new(order, :confirm)
        expect(subject.allow?).to be_falsey
      end

      it ':complete step' do
        order.shipping = user.shipping
        order.billing = user.billing
        order.credit_card = user.credit_card
        subject = Checkout::AccessStep.new(order, :complete)
        expect(subject.allow?).to be_falsey
      end
    end

  end
end
