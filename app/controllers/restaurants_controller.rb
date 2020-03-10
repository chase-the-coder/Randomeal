class RestaurantsController < ApplicationController
  skip_before_action :authenticate_user!
  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def index
    @restaurants = Restaurant.all
    if params[:restaurants][:price] != ""
      prices = [1,2,3,4] - params[:restaurants][:price].split(",").map { |price| price.to_i }
      @restaurants -= Restaurant.where(price_range: prices)
    end
    if params[:restaurants][:categories] != ""
      categories = params[:restaurants][:categories].split(",")
      categories_instances = Category.where(name: categories)
      @restaurants -= Restaurant.where(category_id: categories_instances)
    end
  end
end
