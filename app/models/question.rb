class Question < ApplicationRecord
  has_many :question_comments, dependent: :destroy
  has_many :interests, dependent: :destroy
  has_many :interested_users, through: :interests, source: :user
  belongs_to :user

  validates :title, presence: true
  default_scope -> { order(created_at: :desc) }

  def self.search(keyword)
    Question.where(["title like?", "%#{keyword}%"])
  end
end
