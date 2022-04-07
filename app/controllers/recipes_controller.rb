class RecipesController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy, :following]
  before_action :correct_user_recipe, only: [:edit, :update, :destroy]

  def index
    # @recipes = feed.paginate(page: params[:page])
    @recipes = Recipe.paginate(page: params[:page])
  end

  def show
    @recipe = Recipe.find(params[:id])
    @user = @recipe.user
    @comment = Comment.new
    @comments = @recipe.comments.order(created_at: :desc)
    if @recipe.tag == 1
      @tag = '時短'
    elsif @recipe.tag == 2
      @tag = '格安'
    else
      false
    end
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

  def search
    @recipes = Recipe.search(params[:keyword])
    @keyword = params[:keyword]
  end

  def short_time
    @recipes = Recipe.where(tag: 1)
    @title = '時短'
    render 'show_tag'
  end

  def low_cost
    @recipes = Recipe.where(tag: 2)
    @title = '格安'
    render 'show_tag'
  end

  def following
    # @following_recipes = Recipe.where(user_id: [current_user.following_ids]) if logged_in?
    @following_recipes = Recipe.where(user_id: [current_user.following_ids]).paginate(page: params[:page])
    render 'show_following'
  end

  private
    def recipe_params
      params.require(:recipe).permit(:title, :ingredient, :body, :image, :tag, :duration, :cost)
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
