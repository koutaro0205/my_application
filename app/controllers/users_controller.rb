class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers, :favorite_recipes]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    if @user.activated?
      true
    else
      flash[:warning] = "有効化されていないユーザーです"
      redirect_to root_path
    end
    @recipes = @user.recipes.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.image.attach(params[:user][:image])
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "アカウントの有効化を行うため、メールをご確認ください"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      flash[:success] = "ユーザー情報が更新されました"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = "ユーザーデータを削除しました"
    redirect_to users_url
  end

  def following
    @title = "フォロー中"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "フォロワー"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def favorite_recipes
    @title = "あなたのお気に入りレシピ"
    @favorite_recipes = current_user.favorite_recipes.paginate(page: params[:page])
    render 'show_favorite'
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :image)
    end

    def correct_user
      @user = User.find_by(id: params[:id])
      if current_user?(@user)
        true
      else
        redirect_to root_url
      end
    end

    def admin_user
      if current_user.admin?
        true
      else
        flash[:danger] = "権限がありません"
        redirect_to root_url
      end
    end
end
