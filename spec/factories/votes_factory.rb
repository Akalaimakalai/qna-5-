FactoryBot.define do
  factory :vote do
    association :votable
    user
    value { 1 }
  end
end
