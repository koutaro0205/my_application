class FavoritesController < ApplicationController
  before_action :logged_in_user

  def create
    @recipe = Recipe.find(params[:recipe_id])
    current_user.favorite(@recipe)
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
  end

  def destroy
    @recipe = Favorite.find(params[:id]).recipe
    current_user.unfavorite(@recipe)
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
  end
end
