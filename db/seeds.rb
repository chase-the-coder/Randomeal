require 'json'
require 'open-uri'

# Category seeding

Restaurant.delete_all
puts "Deleted all Restaurants"

Category.delete_all
puts "Deleted all Categories"

url = "https://developers.zomato.com/api/v2.1/cuisines?city_id=73&apikey=a4f1d85868c5fa3598a0e5580a1a2215"
restaurant_api = open(url).read
api = JSON.parse(restaurant_api)
puts "Parsed Zomato API"

api["cuisines"].each_with_index do |a|
  Category.create!(name: a["cuisine"]["cuisine_name"])
end
puts "Category seeds created with success"

# Restaurant seeding

url = "https://developers.zomato.com/api/v2.1/search?entity_id=73&entity_type=city&apikey=a4f1d85868c5fa3598a0e5580a1a2215"
restaurant_api = open(url).read
api = JSON.parse(restaurant_api)
puts "Parsed Zomato API"

api["restaurants"].each do |a|
  Restaurant.create!(
    name: a["restaurant"]["name"],
    zomato_rest_id: a["restaurant"]["id"],
    address: a["restaurant"]["location"]["address"],
    latitude: a["restaurant"]["location"]["latitude"],
    longitude: a["restaurant"]["location"]["longitude"],
    rating: a["restaurant"]["user_rating"]["aggregate_rating"].to_f,
    price_range: a["restaurant"]["price_range"],
    image: a["restaurant"]["photos"][0]["photo"]["url"],
    category_id: Category.find_by(name: a["restaurant"]["cuisines"].split(",")[0]).id
    )
end
puts "Restaurant seeds created with success"
