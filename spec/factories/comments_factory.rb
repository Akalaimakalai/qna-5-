FactoryBot.define do
  factory :comment do
    body { "TestComment" }
    user
    association :commentable
  end
end
