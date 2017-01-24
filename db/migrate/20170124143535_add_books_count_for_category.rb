class AddBooksCountForCategory < ActiveRecord::Migration[5.0]
  def self.up
    add_column :categories, :books_count, :integer, default: 0

    Category.reset_column_information
    Category.all.each do |category|
      Category.update_counters category.id, books_count: category.books.length
    end
  end

  def self.down
    remove_column :categories, :books_count
  end
end
