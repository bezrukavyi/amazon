class CreateCoupons < ActiveRecord::Migration[5.0]
  def change
    create_table :coupons do |t|
      t.boolean :active, default: true
      t.integer :discount
      t.string :code, index: true, unique: true
      t.references :order, foreign_key: true

      t.timestamps
    end
  end
end
