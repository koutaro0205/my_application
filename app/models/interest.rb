class Interest < ApplicationRecord
  belongs_to :user
  belongs_to :question

  validates_uniqueness_of :question_id, scope: :user_id
  validates :user_id, presence: true
  validates :question_id, presence: true
end
