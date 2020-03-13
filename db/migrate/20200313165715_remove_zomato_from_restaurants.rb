class RemoveZomatoFromRestaurants < ActiveRecord::Migration[5.2]
  def change
    remove_column :restaurants, :zomato_rest_id
  end
end
