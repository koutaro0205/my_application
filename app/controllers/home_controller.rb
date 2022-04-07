class HomeController < ApplicationController
  def index
    @recipes = Recipe.limit(6)
    @following_recipes = Recipe.where(user_id: [current_user.following_ids]).limit(9) if logged_in?
    @favorite_recipes = Recipe.includes(:user_favorites).sort{|a,b| b.user_favorites.size <=> a.user_favorites.size}.first(6)
    # @user_favorites = Recipe.includes(:user_favorites).sort{|a,b| b.user_favorites.size <=> a.user_favorites.size}
    # @favorite_recipes = Recipe.where(user_id: [@user_favorites]).limit(3)
  end
end
