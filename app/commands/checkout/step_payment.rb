module Checkout
  class StepPayment < Rectify::Command
    attr_reader :order, :payment_form

    def initialize(options)
      @order = options[:order]
      payment_attrs = options[:params][:order][:credit_card_attributes]
      @payment_form = CreditCardForm.from_params(payment_attrs)
    end

    def call
      if payment_form.valid? && update_order
        broadcast(:valid)
      else
        broadcast :invalid, payment_form: payment_form
      end
    end

    private

    def update_order
      order.assign_attributes(credit_card: credit_card)
      order.credit_card.changed? ? order.save : true
    end

    def credit_card
      card = CreditCard.find_or_initialize_by(number: payment_form.number)
      card.name = payment_form.name
      card.cvv = payment_form.cvv
      card.month_year = payment_form.month_year
      card.tap(&:save)
    end
  end
end
