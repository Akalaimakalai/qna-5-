require 'rails_helper'

RSpec.describe Question, type: :model do
  include_examples "links"
  include_examples "votes", :question
  include_examples "comments"

  it { should belong_to :user }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_one(:medal).dependent(:destroy) }

  it 'have many attached file' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it { should accept_nested_attributes_for :medal }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  describe 'reputation' do
    let(:question) { build(:question) }

    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end
end
