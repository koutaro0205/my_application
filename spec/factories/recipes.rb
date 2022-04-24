FactoryBot.define do
  factory :recipe do
    title {"レシピタイトル"}
    ingredient {"レシピの材料を紹介"}
    body {"レシピの作り方、説明が入ります"}
    duration {30}
    cost {100}
    association :user

    trait :with_comments do
      after(:create) { |recipe| create_list(:comment, 5, recipe: recipe) }
    end

    trait :with_attachment do
      attachment { Rack::Test::UploadedFile.new("#{Rails.root}/spec/files/testImage.jpeg", 'image/jpeg') }
    end

    trait :with_favorites do
      after(:create) { |recipe| create_list(:favorite, 5, recipe: recipe) }
    end
  end

  factory :most_recent, class: Recipe do
    title {"最新のレシピタイトル"}
    ingredient {"最新のレシピの材料を紹介"}
    body {"最新のレシピの作り方、説明が入ります"}
    created_at { Time.zone.now }
    duration {40}
    cost {200}
    user { association :user, email: 'recent@example.com' }

    # trait :with_comments do
    #   after(:create) { |recipe| create_list(:comment, 5, recipe: recipe) }
    # end
  end

  factory :continuous_recipes, class: Recipe do
    sequence(:title) { |n| "レシピタイトル #{n}" }
    sequence(:ingredient) { |n| "材料 #{n}" }
    body {"レシピの作り方、説明が入ります"}
    duration {30}
    cost {100}
    association :user
  end

  factory :recipe_by_user1, class: Recipe do
    title {"レシピタイトル"}
    ingredient {"レシピの材料を紹介"}
    body {"レシピの作り方、説明が入ります"}
    created_at { Time.zone.now }
    duration {30}
    cost {100}
    user factory: :user
  end

  factory :recipe_by_user2, class: Recipe do
    title {"レシピタイトル"}
    ingredient {"レシピの材料を紹介"}
    body {"レシピの作り方、説明が入ります"}
    created_at { Time.zone.now }
    duration {30}
    cost {100}
    user factory: :other_user
  end

  factory :recipe_by_user3, class: Recipe do
    title {"レシピタイトル"}
    ingredient {"レシピの材料を紹介"}
    body {"レシピの作り方、説明が入ります"}
    created_at { Time.zone.now }
    duration {30}
    cost {100}
    user factory: :other_user2
  end
end
def user_with_posts(posts_count: 5)
  FactoryBot.create(:user) do |user|
    FactoryBot.create_list(:recipe, posts_count, user: user)
  end
end
