class HomeController < ApplicationController
  before_action :set_q, only: [:index]
  def index
    @recipes = Recipe.limit(9)
    @following_recipes = Recipe.where(user_id: [current_user.following_ids]).limit(9) if logged_in?
    @favorite_recipes = Recipe.includes(:user_favorites).sort{|a,b| b.user_favorites.size <=> a.user_favorites.size}.first(9)
    @categories = Category.all
    @question_items = Question.order(created_at: :desc).limit(8)
  end
end
