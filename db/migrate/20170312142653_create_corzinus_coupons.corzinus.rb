# This migration comes from corzinus (originally 20170213100003)
class CreateCorzinusCoupons < ActiveRecord::Migration[5.0]
  def change
    create_table :corzinus_coupons do |t|
      t.integer :discount
      t.string :code, index: true, unique: true
      t.references :order, index: true

      t.timestamps
    end
  end
end
