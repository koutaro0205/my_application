class InterestsController < ApplicationController
  before_action :logged_in_user

  def create
    @question = Question.find(params[:question_id])
    current_user.interested_in(@question)
    # redirect_back(fallback_location: root_path)
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
  end

  def destroy
    @question = Interest.find(params[:id]).question
    current_user.not_interested_in(@question)
    # redirect_back(fallback_location: root_path)
    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end
  end
end
