require 'rails_helper'

RSpec.describe Ability do

  subject(:ability) { Ability.new(user) }

  describe "for guest" do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe "for admin" do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all}
  end

  describe "for user" do
    let(:user) { create(:user) }
    let(:user_question) { build(:question, user: user) }
    let(:question) { build(:question) }
    let(:user_answer) { build(:answer, user: user) }
    let(:answer) { build(:answer) }
    let(:user_comment) { build(:comment, commentable: question, user: user) }
    let(:comment) { build(:comment, commentable: question) }
    let(:user_file) { build(:answer, :with_file, user: user).files.first }
    let(:file) { build(:answer, :with_file).files.first }
    let(:user_link) { build(:link, linkable: user_question) }
    let(:link) { build(:link, linkable: question) }

    it { should be_able_to :read, :all }

    context "Question" do
      it { should be_able_to :create, Question }

      it { should be_able_to :update, user_question }
      it { should_not be_able_to :update, question }

      it { should be_able_to :destroy, user_question }
      it { should_not be_able_to :destroy, question }
    end

    context "Answer" do
      it { should be_able_to :create, Answer }

      it { should be_able_to :update, user_answer }
      it { should_not be_able_to :update, answer }

      it { should be_able_to :destroy, user_answer }
      it { should_not be_able_to :destroy, answer }

      it { should be_able_to :best, user_answer }
      it { should_not be_able_to :best, answer }
    end

    context "Comment" do
      it { should be_able_to :create, Comment }

      it { should be_able_to :destroy, user_comment }
      it { should_not be_able_to :destroy, comment }
    end

    context "File" do
      it { should be_able_to :destroy, user_file }
      it { should_not be_able_to :destroy, file }
    end

    context "Link" do
      it { should be_able_to :destroy, user_link }
      it { should_not be_able_to :destroy, link }
    end

    context "Vote" do
      it { should be_able_to :create, Vote.new(votable: answer) }
      it { should_not be_able_to :create, Vote.new(votable: user_answer) }
    end
  end
end
