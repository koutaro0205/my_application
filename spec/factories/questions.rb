FactoryBot.define do
  factory :question do
    user { nil }
    title { "MyString" }
    content { "MyText" }
  end
end
