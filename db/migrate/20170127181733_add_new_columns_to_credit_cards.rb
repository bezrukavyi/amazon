class AddNewColumnsToCreditCards < ActiveRecord::Migration[5.0]
  def change
    add_column :credit_cards, :name, :string
    add_column :credit_cards, :month_year, :string
  end
end
