require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to :score }
  it { should belong_to :user }
  it { should validate_presence_of :value }
end