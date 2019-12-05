FactoryBot.define do
  factory :link do
    name { "Yandex" }
    url { "http://yandex.ru/" }
    association :linkable
  end
end
