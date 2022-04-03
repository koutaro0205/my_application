class HomeController < ApplicationController
  def index
    @recipes = Recipe.limit(6)
    @following_recipes = Recipe.where(user_id: [current_user.following_ids]) if logged_in?
    @favorite_recipes = Recipe.where(user_id: [current_user.favorite_recipes]) if logged_in?
  end
end
