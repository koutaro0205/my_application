class QuestionsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_question, only: [:show, :edit, :update, :destroy]

  def index
    @questions = Question.paginate(page: params[:page])
  end

  def new
    @question = current_user.questions.build if logged_in?
  end

  def show
    @question_comment = @question.question_comments.build
    @question_comments = @question.question_comments.order(created_at: :desc)
    @user = @question.user
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      flash[:success] = '質問を投稿しました'
      redirect_to @question
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @question.update(question_params)
      flash[:success] = "質問の内容が更新されました"
      redirect_to @question
    else
      render 'edit'
    end
  end

  def destroy
    @question.destroy
    flash[:success] = "質問を削除しました"
    redirect_to questions_path
  end

  def search
    @questions = Question.search(params[:keyword]).paginate(page: params[:page])
    @keyword = params[:keyword]
  end

  private
    def set_question
      @question = Question.find(params[:id])
    end

    def question_params
      params.require(:question).permit(:title, :content)
    end
end
