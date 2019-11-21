FactoryBot.define do
  factory :answer do
    body { "MyAnswerText" }
    question
    user
    best_for { nil }

    trait :invalid do
      body { nil }
    end
  end
end
