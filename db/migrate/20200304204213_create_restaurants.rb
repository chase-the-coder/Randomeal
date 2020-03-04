class CreateRestaurants < ActiveRecord::Migration[5.2]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.references :category, foreign_key: true
      t.string :address
      t.string :price_range
      t.string :image
      t.float :rating

      t.timestamps
    end
  end
end
