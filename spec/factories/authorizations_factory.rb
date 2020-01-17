FactoryBot.define do
  factory :authorization do
    user
    provider { "TestProvider" }
    uid { 123321 }
  end
end
