class QuestionCommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user_question_comment, only: [:destroy]

  def create
    @question = Question.find_by(id: params[:question_id])
    @question_comment =  @question.question_comments.build(question_comment_params)
    if @question_comment.save
      flash[:success] = "コメントが投稿されました。"
      redirect_to @question
    else
      flash[:danger] = 'コメントを140文字以内で入力してください'
      redirect_to @question
    end
  end

  def destroy
    if @question_comment.destroy
      flash.now[:success] = 'コメントを削除しました。'
      redirect_back(fallback_location: root_path)
    else
      flash[:danger] = 'コメント削除に失敗しました'
      redirect_back(fallback_location: root_path)
    end
  end

  private
    def question_comment_params
      params.require(:question_comment).permit(:content).merge(user_id: current_user.id)
    end

    def correct_user_question_comment
      @question_comment = QuestionComment.find(params[:id])
      redirect_to(questions_path) unless @question_comment.user == current_user
    end
end
