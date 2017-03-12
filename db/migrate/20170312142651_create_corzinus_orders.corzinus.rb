# This migration comes from corzinus (originally 20170213081058)
class CreateCorzinusOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :corzinus_orders do |t|
      t.string :state
      t.decimal :total_price, precision: 10, scale: 2
      t.boolean :use_base_address
      t.references :delivery, index: true
      t.references :credit_card, index: true
      t.integer :person_id, index: true

      t.timestamps
    end
  end
end
