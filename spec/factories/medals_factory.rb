FactoryBot.define do
  factory :medal do
    name { 'Test medal' }
    image { Rack::Test::UploadedFile.new('/home/artur/Pictures/best_medal.png') }
    question
  end
end
