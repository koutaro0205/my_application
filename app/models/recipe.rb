class Recipe < ApplicationRecord
  has_one_attached :image

  has_many :comments, dependent: :destroy

  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :ingredient, presence: true
end
