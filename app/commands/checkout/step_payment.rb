class Checkout::StepPayment < Rectify::Command

  attr_reader :order, :payment_form

  def initialize(options)
    @order = options[:order]
    @payment_form = options[:payment_form]
  end

  def call
    if payment_form.valid? && update_order
      broadcast(:valid)
    else
      broadcast(:invalid)
    end
  end

  private

  def update_order
    order.update_attributes(credit_card: credit_card)
  end

  def credit_card
    CreditCard.first_or_create(number: payment_form.number) do |credit_card|
      credit_card.name = payment_form.name
      credit_card.cvv = payment_form.cvv
      credit_card.month_year = payment_form.month_year
    end
  end

end
