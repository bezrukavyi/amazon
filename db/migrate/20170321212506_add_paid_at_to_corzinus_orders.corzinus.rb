# This migration comes from corzinus (originally 20170318195429)
class AddPaidAtToCorzinusOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :corzinus_orders, :paid_at, :datetime
  end
end
