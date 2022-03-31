class HomeController < ApplicationController
  def index
    @recipes = Recipe.limit(6)
    @following_feed = current_user.feed.limit(6) if logged_in?
  end
end
