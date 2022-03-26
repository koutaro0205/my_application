class UsersController < ApplicationController
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end
  
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.image.attach(params[:user][:image])
    if @user.save
      flash[:success] = "ユーザー登録が完了しました"
      log_in @user
      redirect_to @user
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

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :image)
    end

    def logged_in_user
      if logged_in?
        true
      else
        session[:forwarding_url] = request.original_url if request.get?
        flash[:danger] = "ログインが必要です"
        redirect_to login_url
      end
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
