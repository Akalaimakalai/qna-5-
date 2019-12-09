require 'rails_helper'

RSpec.describe GistService do

  let(:service) { GistService.new(client: OktokitImitator.new) }

  describe '#gist?(url)' do

    context 'correct url to gist' do
      let(:url) { 'https://gist.github.com/Akalaimakalai/52052829173db67ca71032268fd65e84' }

      it 'returns true' do
        expect(service).to be_gist(url)
      end
    end

    context 'url to gist with error' do
      let(:url) { 'https://gist.github.com/Akalaimakalai/ololonaborsimvolov111' }

      it 'returns false' do
        expect(service).to_not be_gist(url)
      end
    end

    context 'url to not gist' do
      let(:url) { 'https://google.ru/' }

      it 'returns false' do
        expect(service).to_not be_gist(url)
      end
    end
  end
end
