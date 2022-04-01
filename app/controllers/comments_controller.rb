class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create]

  def create
    @recipe = Recipe.find_by(id: params[:recipe_id])
    @comment = Comment.new(comment_params)
    if @comment.save
      flash[:success] = "コメントが投稿されました"
      redirect_to @recipe
    else
      flash[:alert] = 'コメントの投稿に失敗しました'
      redirect_to @recipe
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:content).merge(user_id: current_user.id, recipe_id: params[:recipe_id])
    end
end
