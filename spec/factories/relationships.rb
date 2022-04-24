FactoryBot.define do
  factory :follower, class: Relationship do
    follower_id { 1 }
    followed_id { 1 }
  end
 
  factory :following, class: Relationship do
    follower_id { 1 }
    followed_id { 1 }
  end
end
 
def create_relationships
  10.times do
    FactoryBot.create(:continuous_users)
  end
 
  FactoryBot.create(:user) do |user|
    User.all[0...-1].each do |other|
      FactoryBot.create(:follower, follower_id: other.id, followed_id: user.id)
      FactoryBot.create(:following, follower_id: user.id, followed_id: other.id)
    end
    user
  end
end

def create_following_recipes
  10.times do
    FactoryBot.create(:continuous_users)
  end
 
  FactoryBot.create(:user) do |user|
    User.all[0...-1].each do |other|
      FactoryBot.create(:following, follower_id: user.id, followed_id: other.id)
      FactoryBot.create(:continuous_recipes, user_id: other.id)
    end
    user
  end
end