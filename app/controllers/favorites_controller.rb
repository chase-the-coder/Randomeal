class FavoritesController < ApplicationController

  def create
    favorite = Favorite.new(params_favorite)
    favorite.user = current_user
    favorite.restaurant = Restaurant.find(params[:id])
  end

  def destroy
    favorite = current_user.favorites.where(restaurant: 1)
    favorite.destroy
  end

  private

  def params_favorite
    params.require(:favorite).permit(:user_id, :restaurant_id)
  end
end
