class CreateCreditCards < ActiveRecord::Migration[5.0]
  def change
    create_table :credit_cards do |t|
      t.references :order, foreign_key: true
      t.string :number
      t.string :cvv
      t.string :first_name
      t.string :last_name
      t.integer :month
      t.integer :year

      t.timestamps
    end
  end
end
