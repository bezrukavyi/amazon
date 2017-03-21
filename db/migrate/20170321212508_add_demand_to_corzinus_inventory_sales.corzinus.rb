# This migration comes from corzinus (originally 20170319121949)
class AddDemandToCorzinusInventorySales < ActiveRecord::Migration[5.0]
  def change
    add_column :corzinus_inventory_sales, :demand, :integer
  end
end
