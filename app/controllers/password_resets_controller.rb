class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]

  def new
  end

  def create
    @user = User.find_by(email: params[:password_reset][:email])
    if @user
      @user.create_reset_digest
      UserMailer.password_reset(@user).deliver_now
      flash[:info] = "パスワードの再設定方法を記載したメールを送信しました"
      redirect_to root_url
    else
      flash.now[:danger] = "該当するメールアドレスが見つかりません"
      render 'new'
    end
  end

  def edit
  end

  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update(user_params)
      log_in @user
      flash[:success] = "パスワードが再設定されました"
      redirect_to @user
    else
      render 'edit'
      # with validation messages
    end
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:danger] = "再設定されたパスワードの有効期限が切れました"
      redirect_to new_password_reset_url
    end
  end

  private
    def get_user
      @user = User.find_by(email: params[:email])
    end

    def valid_user
      if @user && @user.activated? && @user.authenticated?(reset, params[:id])
        true
      else
        redirect_to root_url
      end
    end

    def user_params
      params.require(:password_reset).permit(:password, :password_confirmation)
    end
end
