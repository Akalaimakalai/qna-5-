FactoryBot.define do
  factory :score do
    association :author, factory: :user
    association :scorable, factory: :question
  end
end
