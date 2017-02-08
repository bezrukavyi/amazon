class AddStateToReview < ActiveRecord::Migration[5.0]
  def change
    add_column :reviews, :state, :string
    remove_column :reviews, :approved, :boolean
  end
end
