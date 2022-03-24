class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      flash[:success] = 'ログインしました'
      log_in user
      redirect_to user
    else
      flash.now[:danger] = 'メールアドレス、もしくはパスワードが異なります。ご確認の上、再度入力してください。'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
