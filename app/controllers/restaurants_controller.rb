require 'open-uri'
require 'nokogiri'
require 'sidekiq'
require 'sidekiq-status'

class RestaurantsController < ApplicationController

  skip_before_action :authenticate_user!
  before_action :filtering_restaurants, only: [:index, :verify]

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def index
    @markers = {
      lat: @restaurant.latitude,
      lng: @restaurant.longitude,
      infoWindow: render_to_string(partial: "info_window", locals: { restaurant: @restaurant })
    }
  end

  def load
    geocoder_obj = Geocoder.search(params[:restaurants][:user_address]).first.data
    location = [geocoder_obj["lat"].to_f, geocoder_obj["lon"].to_f]
    session[:category] = params[:restaurants][:categories]
    session[:price] = params[:restaurants][:price]
    session[:lat] = geocoder_obj["lat"].to_f
    session[:long] = geocoder_obj["lon"].to_f
    session[:distance] = params[:restaurants][:distance]
    # session[:sidekiq_job_id] = CreateRestaurantsJob.perform_later(location)
    parse(location)
  end

  def verify
    render json: {
      found: @restaurant.present?,
    }
  end

  private

  def filtering_restaurants
    @restaurants = Restaurant.all
    location = [session[:lat].to_f, session[:long].to_f]

    if session[:price].present?
      prices = [1,2,3,4] - session[:price].split(",").map { |price| price.to_i }
      @restaurants -= Restaurant.where(price_range: prices)
    end
    if session[:category].present?
      categories = session[:category].split(",")
      if categories.include?("Bar")
        categories << "Bar Food"
        categories << "Bars"
      end
      if categories.include?("Cafe")
        categories << "Café"
        categories << "Cafe Food"
        categories << "Coffee Bar"
        categories << "Coffee Shop"
        categories << "Caffe"
        categories << "Caffé"
        categories << "Cafe Bar"
        categories << "Café Bar"
        categories << "Cafés"
      end
      if categories.include?("Fast Food")
        categories << "Snack Bar"
      end
      if categories.include?("Japanese")
        categories << "Sushi"
        categories << "Lamen Shop"
      end
      if categories.include?("Burger")
        categories << "Burgers"
      end
      if categories.include?("Steak")
        categories << "Steakhouse"
        categories << "Grill"
        categories << "Churrascaria"
      end
      if categories.include?("Seafood")
        categories << "Sea Food"
      end
      if categories.include?("Vegetarian")
        categories << "Vegan"
      end
      categories_instances = Category.where(name: categories)
      @restaurants -= Restaurant.where(category_id: categories_instances)
    end
    if session[:distance].present?
      if @restaurants.any?
        @restaurants = @restaurants.reject do |rest|
          rest.latitude.nil? || rest.distance_to([session[:lat], session[:long]]) > session[:distance].to_i
        end
      end
    end
    @restaurant = @restaurants.sample
  end

  def parse
    start = 0
    counter = 0
    hash = {}

    5.times do

      url = "https://www.yelp.com/search?find_desc=Restaurants&find_loc=#{location[0]} #{location[1]}&start=#{start}"
      email = "#{rand(99999..999999999999)}@gmail.com"
      html_file = open(url, "User-Agent" => "Ruby/2.6.5",
          "From" => email,
          "Referer" => "http://www.ruby-lang.org/").read
      html_doc = Nokogiri::HTML(html_file)

      break if html_doc.search("h3").first.text.include?("We're sorry, the page of results you requested is unavailable.")

      css_class = "li.lemon--li__373c0__1r9wz > div.lemon--div__373c0__1mboc > div.lemon--div__373c0__1mboc"

      html_doc.search(css_class).each_with_index do |element, index|

        next if element.search('.lemon--span__373c0__3997G .priceRange__373c0__2DY87').empty?

        hash[counter.to_s] = {}

        element.search('.lemon--h4__373c0__1yd__').each do |el|
          hash[counter.to_s]["name"] = el.text.gsub(/[[0-9].]/, "")[1..-1]
        end

        element.search('.lemon--p__373c0__3Qnnj .lemon--span__373c0__3997G').each do |el|
          hash[counter.to_s]["address"] = el.text unless el.text.include?("Miles") ||  el.text.include?("Offers") ||  el.text.include?("more")
        end

        element.search('.lemon--span__373c0__3997G .priceRange__373c0__2DY87').each do |el|
          hash[counter.to_s]["price"] = el.text.size
        end

        hash[counter.to_s]["category"] = element.search('.lemon--span__373c0__3997G .lemon--span__373c0__3997G .lemon--a__373c0__IEZFH').map(&:text).join(",")

        element.search('.lemon--a__373c0__IEZFH .lemon--img__373c0__3GQUb').each do |el|
          hash[counter.to_s]["photo"] = el.attribute('src').value if el.attribute('src').value.include?("bphoto")
        end

        element.search('.lemon--span__373c0__3997G .i-stars__373c0__tb0kH').each do |el|
          hash[counter.to_s]["rating"] = el.values[-2][0..-13].to_f
        end
        counter += 1
      end
      start += 30
      hash.each do |key, _value|
        hash[key]["category"].split(",").each do |category|
          Category.find_or_create_by(name: category)
        end
      end

      hash.each do |key, _value|
        Restaurant.find_or_create_by(
          name: hash[key]["name"],
          address: hash[key]["address"],
          rating: hash[key]["rating"],
          price_range: hash[key]["price"],
          image: hash[key]["photo"],
          category_id: Category.find_by(name: hash[key]["category"].split(",")[0]).id
        )
      end
    end
  end

end
