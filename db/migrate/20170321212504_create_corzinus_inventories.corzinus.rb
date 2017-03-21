# This migration comes from corzinus (originally 20170318163804)
class CreateCorzinusInventories < ActiveRecord::Migration[5.0]
  def change
    create_table :corzinus_inventories do |t|
      t.integer :count
      t.references :productable, polymorphic: true, index: { name: 'index_corzinus_inventory_productable' }
      t.timestamps
    end
  end
end
