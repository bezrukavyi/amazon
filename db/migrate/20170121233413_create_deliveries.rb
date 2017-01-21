class CreateDeliveries < ActiveRecord::Migration[5.0]
  def change
    create_table :deliveries do |t|
      t.string :name
      t.decimal :price, precision: 10, scale: 2
      t.integer :min_days
      t.integer :max_days
      t.references :country, foreign_key: true

      t.timestamps
    end
  end
end
