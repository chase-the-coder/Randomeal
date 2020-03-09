class AddTimingsToRestaurant < ActiveRecord::Migration[5.2]
  def change
    add_column :restaurants, :timings, :string
  end
end
