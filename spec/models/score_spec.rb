require 'rails_helper'

RSpec.describe Score, type: :model do
  it { should belong_to(:scorable) }
  it { should belong_to(:author) }

  it { should validate_presence_of(:sum) }
end
