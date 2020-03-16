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
    session[:sidekiq_job_id] = CreateRestaurantsJob.perform_later(location)
  end

  def verify
    should_stop = Sidekiq::Status::complete? session[:sidekiq_job_id]["job_id"]

    render json: {
      found: @restaurant.present?,
      should_stop: should_stop
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


end
