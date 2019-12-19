RSpec.shared_examples "votes" do
  it { should have_many(:votes).dependent(:destroy) }
end
