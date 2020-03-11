require 'open-uri'
require 'nokogiri'

class RestaurantsController < ApplicationController
  skip_before_action :authenticate_user!
  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def index
    location = [params[:restaurants][:user_lat].to_f, params[:restaurants][:user_long].to_f]
    CreateRestaurantsJob.perform_later(scrape(location))
    @restaurants = Restaurant.where.not(latitude: nil, longitude: nil)
    if params[:restaurants][:price] != ""
      prices = [1,2,3,4] - params[:restaurants][:price].split(",").map { |price| price.to_i }
      @restaurants -= Restaurant.where(price_range: prices)
    end
    if params[:restaurants][:categories] != ""
      categories = params[:restaurants][:categories].split(",")
      categories_instances = Category.where(name: categories)
      @restaurants -= Restaurant.where(category_id: categories_instances)
    end
    if params[:restaurants][:distance] != ""
      @restaurants.reject do |rest|
        rest.distance_to([location[0], location[1]]) <= params[:restaurants][:distance].to_i
      end
    end
    @restaurant = @restaurants.sample

    @markers = {
      lat: @restaurant.latitude,
      lng: @restaurant.longitude,
      infoWindow: render_to_string(partial: "info_window", locals: { restaurant: @restaurant })
    }

  end

  private

  def scrape(location)
    start = 0
    counter = 0
    hash = {}

    1.times do

      url = "https://www.yelp.com/search?find_desc=Restaurants&find_loc=#{location[0]} #{location[1]}&start=#{start}"

      html_file = open(url, "User-Agent" => "Ruby/2.6.5",
          "From" => "foo@gmail.com",
          "Referer" => "http://www.ruby-lang.org/").read
      html_doc = Nokogiri::HTML(html_file)

      css_class = "li.lemon--li__373c0__1r9wz > div.lemon--div__373c0__1mboc > div.lemon--div__373c0__1mboc"

      html_doc.search(css_class).each_with_index do |element, index|

        next if element.search('.lemon--span__373c0__3997G .priceRange__373c0__2DY87').empty?

        hash[counter] = {}

        element.search('.lemon--h4__373c0__1yd__').each do |el|
          hash[counter]["name"] = el.text.gsub(/[[0-9].]/, "")[1..-1]
        end

        element.search('.lemon--p__373c0__3Qnnj .lemon--span__373c0__3997G').each do |el|
          hash[counter]["address"] = el.text if el.text.size > 9
        end

        element.search('.lemon--span__373c0__3997G .priceRange__373c0__2DY87').each do |el|
          hash[counter]["price"] = el.text.size
        end

        hash[counter]["category"] = element.search('.lemon--span__373c0__3997G .lemon--span__373c0__3997G .lemon--a__373c0__IEZFH').map(&:text).join(",")

        element.search('.lemon--a__373c0__IEZFH .lemon--img__373c0__3GQUb').each do |el|
          hash[counter]["photo"] = el.attribute('src').value if el.attribute('src').value.include?("bphoto")
        end

        element.search('.lemon--span__373c0__3997G .i-stars__373c0__tb0kH').each do |el|
          hash[counter]["rating"] = el.values[-2][0..-13].to_f
        end
        counter += 1
      end
      start += 30
    end
    hash
  end
end
