FactoryBot.define do
  sequence :title do |n|
    "Very_uniq_title_##{n}"
  end

  factory :question do
    title
    body { "MyQuestionText" }
    user

    trait :invalid do
      title { nil }
    end
  end
end
