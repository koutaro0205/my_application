class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :admin_user, only: [:index, :create, :edit, :update, :destroy ]

  def show
    @recipes = @category.recipes.paginate(page: params[:page])
  end

  def index
    @category = Category.new
    @categories = Category.all
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to categories_path
    else
      @categories = Category.all
      render 'index'
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to categories_path
      flash[:success] = 'カテゴリの更新に成功しました'
    else
      render 'edit'
    end
  end

  def destroy
    @category.destroy
    redirect_to categories_path
  end

  private

    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name)
    end

    def admin_user
      unless current_user.admin?
        flash[:danger] = "権限がありません"
        redirect_to root_url
      end
    end
end
