require 'rails_helper'

RSpec.describe Coment, type: :model do
  it { should belong_to :user }
  it { should belong_to :comentable }

  it { should validate_presence_of :body }
end
