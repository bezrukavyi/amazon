class CreateJoinTableBookMaterial < ActiveRecord::Migration[5.0]
  def change
    create_join_table :books, :materials do |t|
      t.index [:book_id, :material_id]
    end
  end
end
