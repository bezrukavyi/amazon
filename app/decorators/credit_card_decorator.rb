class CreditCardDecorator < Draper::Decorator
  delegate_all

  def hidden_number
    hidden = '** ' * 3
    hidden + number.last(4)
  end
end
