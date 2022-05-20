class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]
  before_action :admin_user, only: [:new, :create, :edit, :update, :destroy ]

  def show
    @recipes = @category.recipes.paginate(page: params[:page])
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to root_path
    else
      @categories = Category.all
      render 'new'
    end
  end

  def edit
  end

  def update
    if @category.update(category_params)
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def destroy
    @category.destroy
    redirect_to root_path
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
