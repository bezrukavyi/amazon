# This migration comes from corzinus (originally 20170213074759)
class CreateCorzinusAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :corzinus_addresses do |t|
      t.string :first_name
      t.string :last_name
      t.string :name
      t.string :city
      t.string :zip
      t.string :phone
      t.integer :address_type
      t.references :addressable, polymorphic: true
      t.references :country, index: true

      t.timestamps
    end
  end
end
