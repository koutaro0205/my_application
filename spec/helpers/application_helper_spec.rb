require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe 'full_title' do
    let(:base_title) { 'ZuboRecipes' }

    context 'when you pass an argument' do
      it 'returns a string of arguments and a base title' do
        expect(full_title('Page Title')).to eq "Page Title | #{base_title}"
      end
    end

    context 'When there is no argument' do
      it 'returns only the base title' do
        expect(full_title).to eq "#{base_title}"
      end
    end
  end
end