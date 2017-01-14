class AddCodeToCountries < ActiveRecord::Migration[5.0]
  def change
    add_column :countries, :code, :string
  end
end
