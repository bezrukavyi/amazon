class AddUseBaseAddressToOrders < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :use_base_address, :boolean
  end
end
