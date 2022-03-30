class RecipesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :correct_user_recipe, only: [:edit, :update, :destroy]

  def index
    # @recipes = feed.paginate(page: params[:page])
    @recipes = Recipe.paginate(page: params[:page])
  end

  def show
    @recipe = Recipe.find(params[:id])
    @user = @recipe.user
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
      redirect_to @recipe
    else
      render 'new'
    end
  end

  def edit
    @recipe = Recipe.find(params[:id])
    @user = @recipe.user
  end

  def update
    @recipe = Recipe.find(params[:id])
    if @recipe.update(recipe_params)
      flash[:success] = "レシピの内容が更新されました"
      redirect_to @recipe
    else
      render 'edit'
    end
  end

  def destroy
    @recipe = Recipe.find(params[:id])
    @recipe.destroy
    flash[:success] = "レシピを削除しました"
    redirect_to root_url
  end

  private
    def recipe_params
      params.require(:recipe).permit(:title, :ingredient, :body, :image)
    end

    def correct_user_recipe
      @recipe = Recipe.find(params[:id])
      @user = @recipe.user
      if current_user?(@user)
        true
      else
        redirect_to root_url
      end
    end
end
