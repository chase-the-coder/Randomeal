require 'json'
require 'open-uri'

# city_grab = "https://developers.zomato.com/api/v2.1/cities?q=#{city}&apikey=a4f1d85868c5fa3598a0e5580a1a2215"

# Category seeding

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
