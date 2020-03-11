class CreateRestaurantsJob < ApplicationJob
  queue_as :default

  def perform(rest)
    Restaurant.delete_all
    rests.each do |key, _value|
      rests[key]["category"].split(",").each do |category|
        Category.find_or_create_by(name: category)
      end
    end

    rests.each do |key, _value|
      Restaurant.create!(
        name: rests[key]["name"],
        address: rests[key]["address"],
        rating: rests[key]["rating"],
        price_range: rests[key]["price"],
        image: rests[key]["photo"],
        category_id: Category.find_by(name: rests[key]["category"].split(",")[0]).id
      )
    end
  end
end
