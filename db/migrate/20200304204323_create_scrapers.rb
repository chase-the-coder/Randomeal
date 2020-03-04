class CreateScrapers < ActiveRecord::Migration[5.2]
  def change
    create_table :scrapers do |t|
      t.string :city
      t.string :country

      t.timestamps
    end
  end
end
