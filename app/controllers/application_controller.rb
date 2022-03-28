class ApplicationController < ActionController::Base
  include SessionsHelper

  private

  def logged_in_user
    if logged_in?
      true
    else
      session[:forwarding_url] = request.original_url if request.get?
      flash[:danger] = "ログインが必要です"
      redirect_to login_url
    end
  end
end
