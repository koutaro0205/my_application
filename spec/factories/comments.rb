FactoryBot.define do
  factory :comment do
    content {"test content"}
    association :user
    association :recipe
  end
end
