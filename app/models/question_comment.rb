class QuestionComment < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates :question_id, presence: true
  validates :user_id, presence: true
  validates :content, presence: true
end
