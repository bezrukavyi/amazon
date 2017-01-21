class AddIndexToMaterial < ActiveRecord::Migration[5.0]
  def change
    add_index :materials, :name, unique: true
  end
end
