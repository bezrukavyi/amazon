# This migration comes from corzinus (originally 20170213075641)
class CreateCorzinusDeliveries < ActiveRecord::Migration[5.0]
  def change
    create_table :corzinus_deliveries do |t|
      t.string :name
      t.decimal :price, precision: 10, scale: 2
      t.integer :min_days
      t.integer :max_days
      t.references :country, index: true

      t.timestamps
    end
  end
end
