FactoryBot.define do
  factory :vote do
    score
    user
    value { 1 }
  end
end
