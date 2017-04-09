class RemoveOrderReferencesFromCreditCards < ActiveRecord::Migration[5.0]
  def self.up
    remove_reference :credit_cards, :order, foreign_key: true
  end

  def self.down
    add_reference :credit_cards, :order, foreign_key: true
  end
end
