class FavoritesController < ApplicationController
  before_action :logged_in_user

  def create
    # @favorite = Favorite.new(user_id: current_user.id, recipe_id: params[:recipe_id])
    # @favorite.save
    @recipe = Recipe.find(params[:recipe_id])
    current_user.favorite(@recipe)
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
  end

  def destroy
    # @favorite = Favorite.find_by(recipe_id: params[:recipe_id], user_id: current_user.id)
    # @favorite.destroy
    @recipe = Favorite.find(params[:id]).recipe
    current_user.unfavorite(@recipe)
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
  end
end
