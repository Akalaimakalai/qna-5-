require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :question }
  it { should(belong_to :user).optianal }
  it { should validate_presence_of :name }
  it { should validate_presence_of :image }

  it 'have one attached imade' do
    expect(Answer.new.image).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
