class RestaurantsController < ApplicationController
  skip_before_action :authenticate_user!
  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def index
    prices = params[:restaurants][:price].split(",")
    @restaurants = Restaurant.where(price_range: prices)
  end
end
