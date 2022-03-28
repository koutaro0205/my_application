class RecipesController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  def index
    @recipes = Recipe.paginate(page: params[:page])
  end

  def new
    @recipe = current_user.recipes.build if logged_in?
    # @recipe = Recipe.new
  end

  def create
    @recipe = current_user.recipes.build(recipe_params)
    @recipe.image.attach(params[:recipe][:image])
    if @recipe.save
      flash[:success] = "レシピが投稿されました！"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
  end

  def destroy
  end

  private
    def recipe_params
      params.require(:recipe).permit(:title, :ingredient, :body, :image)
    end
end
