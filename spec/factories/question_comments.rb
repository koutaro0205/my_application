FactoryBot.define do
  factory :question_comment do
    user { nil }
    question { nil }
    content { "MyText" }
  end
end
