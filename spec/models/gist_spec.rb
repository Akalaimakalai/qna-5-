require 'rails_helper'

RSpec.describe Gist, type: :model do
  it { should belong_to :link }

  it { should validate_presence_of :name }
  it { should validate_presence_of :content }
  it { should validate_presence_of :url }
end
