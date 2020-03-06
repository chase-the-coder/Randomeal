class AddLatAndLongToRestaurant < ActiveRecord::Migration[5.2]
  def change
    add_column :restaurants, :latitude, :integer
    add_column :restaurants, :longitude, :integer
  end
end
