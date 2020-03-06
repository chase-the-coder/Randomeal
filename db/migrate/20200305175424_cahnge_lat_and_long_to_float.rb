class CahngeLatAndLongToFloat < ActiveRecord::Migration[5.2]
  def change
    remove_column :restaurants, :latitude
    remove_column :restaurants, :longitude
    add_column :restaurants, :latitude, :float
    add_column :restaurants, :longitude, :float
  end
end
