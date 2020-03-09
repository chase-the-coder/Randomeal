class RestaurantsController < ApplicationController
  skip_before_action :authenticate_user!
  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def index
    @restaurants = Restaurant.all
  end
end
