class CreateAddresses < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses do |t|
      t.references :addressable, polymorphic: true
      t.string :first_name
      t.string :last_name
      t.string :address
      t.references :country, foreign_key: true
      t.string :city
      t.string :zip
      t.string :phone

      t.timestamps
    end
  end
end
