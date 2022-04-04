class Recipe < ApplicationRecord
  has_one_attached :image

  has_many :comments, dependent: :destroy

  has_many :favorites, dependent: :destroy
  has_many :user_favorites, through: :favorites, source: :user

  belongs_to :user

  default_scope -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 50 }
  validates :ingredient, presence: true

  def self.search(keyword)
    Recipe.where(["title like? OR body like?", "%#{keyword}%", "%#{keyword}%"])
  end

  # def favorite(recipe)
  #   favorite_recipes << recipe
  # end

  # def unfavorite(recipe)
  #   favorites.find_by(recipe_id: recipe.id).destroy
  # end

  # def favorite?(user)
  #   favorites.where(user_id: user.id).exists?
  # end
end
