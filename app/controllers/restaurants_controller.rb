require 'open-uri'
require 'nokogiri'

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
    location = [params[:restaurants][:user_lat].to_f, params[:restaurants][:user_long].to_f]
    session[:category] = params[:restaurants][:categories]
    session[:price] = params[:restaurants][:price]
    session[:lat] = params[:restaurants][:user_lat]
    session[:long] = params[:restaurants][:user_long]
    session[:distance] = params[:restaurants][:distance]
    current_session = session
    CreateRestaurantsJob.perform_later(location)
  end

  def verify
    render json: {
      found: @restaurant.present?
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
    if session[:categorys].present?
      categories = session[:categories].split(",")
      categories_instances = Category.where(name: categories)
      @restaurants -= Restaurant.where(category_id: categories_instances)
      # puts "========================================="
      # puts @restaurants
      # puts "========================================="
    end
    if session[:distance].present?
      if @restaurants.any?
        @restaurants.reject do |rest|
          rest.distance_to([session[:lat], session[:long]]) <= session[:distance].to_i
        end
      end
    end
    @restaurant = @restaurants.sample
  end


end
