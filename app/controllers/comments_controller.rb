class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user_comment, only: [:destroy]

  def create
    @recipe = Recipe.find_by(id: params[:recipe_id])
    @comment = Comment.new(comment_params)
    if @comment.save
      flash[:success] = "コメントが投稿されました。"
      redirect_to @recipe
    else
      flash[:danger] = 'コメントの投稿に失敗しました。再度入力して下さい。'
      redirect_to @recipe
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.destroy
      flash.now[:success] = 'コメントを削除しました。'
      redirect_back(fallback_location: root_path)
    else
      flash[:danger] = 'コメント削除に失敗しました'
      redirect_back(fallback_location: root_path)
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:content).merge(user_id: current_user.id, recipe_id: params[:recipe_id])
    end

    def correct_user_comment
      @comment = Comment.find(params[:id])
      if @comment.user == current_user
        true
      else
        redirect_to root_url
      end
    end
end
