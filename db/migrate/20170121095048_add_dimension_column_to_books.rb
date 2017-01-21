class AddDimensionColumnToBooks < ActiveRecord::Migration[5.0]
  def change
    add_column :books, :dimension, :json, default: []
  end
end
