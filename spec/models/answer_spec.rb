require 'rails_helper'

RSpec.describe Answer, type: :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { is_expected.to belong_to(:best_for).class_name('Question').optional }

  it { should validate_presence_of :body }
end
