class HomeController < ApplicationController
  def index
    @recipes = Recipe.limit(6)
  end
end
