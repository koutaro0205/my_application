FactoryBot.define do
  factory :favorite, class: Favorite do
    recipe_id { 1 }
    user_id { 1 }
    association :user
    association :recipe
  end

  factory :favorite_recipes, class: Favorite do
    recipe_id { 1 }
    user_id { 1 }
  end
end

def create_favorites
  10.times do
    FactoryBot.create(:continuous_recipes)
  end
 
  FactoryBot.create(:user) do |user|
    Recipe.all[0...-1].each do |recipe|
      FactoryBot.create(:favorite_recipes, user_id: user.id, recipe_id: recipe.id)
    end
    user
  end
end

def create_recipe_lists

  10.times do
    FactoryBot.create(:continuous_users)
  end
 
  FactoryBot.create(:user) do |user|
    User.all[0...-1].each do |other|
      FactoryBot.create(:following, follower_id: user.id, followed_id: other.id)
      recipe = FactoryBot.create(:continuous_recipes, user_id: other.id)
      FactoryBot.create(:favorite_recipes, user_id: user.id, recipe_id: recipe.id)
    end
    user
  end
end
