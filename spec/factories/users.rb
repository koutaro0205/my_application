FactoryBot.define do
  factory :user do
    name { "tester" }
    sequence(:email) { |n| "tester#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    activated { true }
    admin { true }

    trait :with_recipes do
      after(:create) { |user| create_list(:recipe, 5, user: user) }
    end
  end

  factory :continuous_users, class: User do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "user-#{n}@example.com" }
    password { 'password' }
    password_confirmation { 'password' }
    activated { true }
  end

  factory :other_user, class: User do
    name { "otherTester" }
    sequence(:email) { |n| "othertester#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    activated { true }
  end

  factory :other_user2, class: User do
    name { "otherTester" }
    sequence(:email) { |n| "othertester#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
    activated { true }
  end

  factory :not_activated_user, class: User do
    name { "notActivatedUser" }
    sequence(:email) { |n| "notActivatedUser#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
