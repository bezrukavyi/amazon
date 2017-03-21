# This migration comes from corzinus (originally 20170318164952)
class CreateCorzinusInventorySales < ActiveRecord::Migration[5.0]
  def change
    create_table :corzinus_inventory_sales do |t|
      t.integer :start_stock
      t.integer :finish_stock
      t.references :inventory, index: true

      t.timestamps
    end
  end
end
