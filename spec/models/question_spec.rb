require 'rails_helper'

RSpec.describe Question, type: :model do
  include_examples "links"
  include_examples "votes", :question
  include_examples "comments"

  it { should belong_to :user }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:followers).through(:subscriptions).source(:user) }
  it { should have_one(:medal).dependent(:destroy) }

  it 'have many attached file' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it { should accept_nested_attributes_for :medal }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  describe "scope :yesterday" do

    before { Question.delete_all }

    it 'shows all questions for last 24 hours' do
      questions = create_list(:question, 2, created_at: (Time.zone.now - 300))
      question = create(:question, created_at: (Time.zone.now + 500))

      expect(Question.yesterday.count).to eq 2
      questions.each do |q|
        expect(Question.yesterday).to be_include(q)
      end
      expect(Question.yesterday).to_not be_include(question)
    end
  end

  describe 'reputation' do
    let(:question) { build(:question) }

    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end
end
