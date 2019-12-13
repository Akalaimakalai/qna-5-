require 'rails_helper'

RSpec.describe Question, type: :model do
  include_examples "links"
  it { should have_one(:score).dependent(:destroy) }

  it { should belong_to :user }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_one(:medal).dependent(:destroy) }

  it 'have many attached file' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it { should accept_nested_attributes_for :medal }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  describe "#create_score" do
    it 'has to create score after creating itself' do
      expect{ create(:question) }.to change(Score, :count).by(1)
    end
  end
end
