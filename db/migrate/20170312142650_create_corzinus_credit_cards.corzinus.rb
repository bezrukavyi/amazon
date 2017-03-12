# This migration comes from corzinus (originally 20170213080532)
class CreateCorzinusCreditCards < ActiveRecord::Migration[5.0]
  def change
    create_table :corzinus_credit_cards do |t|
      t.string :number
      t.string :name
      t.string :cvv
      t.string :month_year
      t.integer :person_id, index: true

      t.timestamps
    end
  end
end
