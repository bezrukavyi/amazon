class AddImageableToPictures < ActiveRecord::Migration[5.0]
  def change
    add_reference :pictures, :imageable, polymorphic: true
    remove_reference :pictures, :book, foreign_key: true
  end
end
