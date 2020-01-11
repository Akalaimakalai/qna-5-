RSpec.shared_examples "comments" do
  it { should have_many(:comments).dependent(:destroy) }
end
