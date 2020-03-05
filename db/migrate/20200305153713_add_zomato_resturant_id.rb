class AddZomatoResturantId < ActiveRecord::Migration[5.2]
  def change
    add_column :restaurants, :zomato_rest_id, :integer
  end
end
