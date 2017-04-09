class ChangePriceScaleOfBook < ActiveRecord::Migration[5.0]
  def self.up
    change_column :books, :price, :decimal, precision: 10, scale: 2
  end

  def self.down
    change_column :books, :price, :decimal, precision: 12, scale: 3
  end
end
