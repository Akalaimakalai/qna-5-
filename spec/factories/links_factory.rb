FactoryBot.define do
  factory :link do
    name { "Yandex" }
    url { "http://yandex.ru/" }
    association :linkable

    trait :gist do
      name { 'Gist' }
      url { 'https://gist.github.com/Akalaimakalai/52052829173db67ca71032268fd65e84' }
    end
  end
end
