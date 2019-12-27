RSpec.shared_examples "coments" do
  it { should have_many(:coments).dependent(:destroy) }
end
