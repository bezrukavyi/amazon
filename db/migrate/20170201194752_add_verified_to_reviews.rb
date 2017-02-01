class AddVerifiedToReviews < ActiveRecord::Migration[5.0]
  def change
    add_column :reviews, :verified, :boolean, default: false
  end
end
