class AddRefCreditCardToOrders < ActiveRecord::Migration[5.0]
  def change
    add_reference :orders, :credit_card, foreign_key: true
  end
end
