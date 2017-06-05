class CreateCorzinusInventoryAnalyses < ActiveRecord::Migration[5.0]
  def change
    create_table :corzinus_inventory_analyses do |t|
      t.json :inventory_data
      t.json :demand_data
      t.json :price_data
      t.json :original_price_data

      t.float :delivery_cost
      t.float :warehous_cost

      t.string :reserves, array: true

      t.integer :delivery_days

      t.timestamps
    end
  end
end
