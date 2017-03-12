# This migration comes from corzinus (originally 20170213081259)
class CreateCorzinusOrderItems < ActiveRecord::Migration[5.0]
  def change
    create_table :corzinus_order_items do |t|
      t.integer :quantity
      t.references :order, index: true
      t.references :productable, polymorphic: true,
                                 index: { name: 'index_corzinus_productable' }

      t.timestamps
    end
  end
end
