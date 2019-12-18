RSpec.shared_examples "scores" do |obj_sym, count_change|
  it { should have_one(:score).dependent(:destroy) }

  describe "#create_score" do
    it 'has to create score after creating itself' do
      expect{ create(obj_sym) }.to change(Score, :count).by(count_change)
    end
  end
end
