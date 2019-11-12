FactoryBot.define do
  factory :answer do
    body { "MyAnswerText" }
    correct { false }
    question

    trait :invalid do
      body { nil }
    end
  end
end
