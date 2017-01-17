class CreateBooks < ActiveRecord::Migration[5.0]
  def change
    create_table :books do |t|
      t.string :title
      t.text :desc
      t.decimal :price, precision: 12, scale: 3
      t.integer :count

      t.timestamps
    end
    add_index :books, :title
  end
end
