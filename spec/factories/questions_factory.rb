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

    trait :with_file do
      files { Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb") }
    end
  end
end
