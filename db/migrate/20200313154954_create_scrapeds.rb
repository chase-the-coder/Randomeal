class CreateScrapeds < ActiveRecord::Migration[5.2]
  def change
    create_table :scrapeds do |t|
      t.string :city
      t.string :country

      t.timestamps
    end
  end
end
