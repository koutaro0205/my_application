require 'rails_helper'

RSpec.describe "Homes", type: :request do
  let(:base_title) { 'ZuboRecipes' }

  describe "#home" do
    it "responds successfully" do
      get root_path
      expect(response).to be_successful
    end

    it "returns a 200 response" do
      get root_path
      expect(response).to have_http_status "200"
    end

    it 'includes ホーム | ZuboRecipes' do
      get root_path
      expect(response.body).to include full_title('ホーム')
    end
  end
end