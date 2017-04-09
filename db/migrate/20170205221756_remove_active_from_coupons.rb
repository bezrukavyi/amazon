class RemoveActiveFromCoupons < ActiveRecord::Migration[5.0]
  def change
    remove_column :coupons, :active, :boolean
  end
end
