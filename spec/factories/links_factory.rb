FactoryBot.define do
  factory :link do
    name { "QNA" }
    url { "http://localhost:3000/" }
    association :linkable
  end
end
