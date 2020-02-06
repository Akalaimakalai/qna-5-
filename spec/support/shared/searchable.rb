shared_examples_for 'searchable' do
  it 'works correct' do
    expect(service).to receive(:call)
    get :index, params: { search: 'test', classes: klass }
    expect(response).to render_template(:index)
  end
end
