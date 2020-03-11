class RestaurantsController < ApplicationController
  skip_before_action :authenticate_user!
  def show
    @restaurant = Restaurant.find(params[:id])

  end

  def index
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
    @restaurant = @restaurants.sample

    @markers = {
      lat: @restaurant.latitude,
      lng: @restaurant.longitude,
      # infoWindow: render_to_string(partial: "info_window", locals: { restaurant: restaurant })
      }
  end
end
