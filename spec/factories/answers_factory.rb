FactoryBot.define do
  factory :answer do
    body { "MyAnswerText" }
    question
    user

    trait :invalid do
      body { nil }
    end

    trait :with_file do
      ActiveStorage::Current.host = 'localhost:3000'
      files { Rack::Test::UploadedFile.new("#{Rails.root}/spec/rails_helper.rb") }
    end
  end
end
