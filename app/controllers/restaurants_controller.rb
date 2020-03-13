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
    current_session = session
    filtering_restaurants
    session[:sidekiq_job_id] = CreateRestaurantsJob.perform_later(location) unless @restaurant
  end

  def verify
    if session[:sidekiq_job_id]
      should_stop = Sidekiq::Status::complete? session[:sidekiq_job_id]["job_id"]
    else
      should_stop = false
    end

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
