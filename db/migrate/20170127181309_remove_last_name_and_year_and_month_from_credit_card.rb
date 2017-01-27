class RemoveLastNameAndYearAndMonthFromCreditCard < ActiveRecord::Migration[5.0]
  def change
    remove_column :credit_cards, :first_name, :string
    remove_column :credit_cards, :last_name, :string
    remove_column :credit_cards, :month, :integer
    remove_column :credit_cards, :year, :integer
  end
end
