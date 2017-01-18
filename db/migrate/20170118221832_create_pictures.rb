class CreatePictures < ActiveRecord::Migration[5.0]
  def change
    create_table :pictures do |t|
      t.string :path
      t.references :book, foreign_key: true

      t.timestamps
    end
  end
end
