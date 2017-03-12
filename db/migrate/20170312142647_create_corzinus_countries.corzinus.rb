# This migration comes from corzinus (originally 20170212215236)
class CreateCorzinusCountries < ActiveRecord::Migration[5.0]
  def change
    create_table :corzinus_countries do |t|
      t.string :name
      t.string :code

      t.timestamps
    end
  end
end
