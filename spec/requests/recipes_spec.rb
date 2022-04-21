require 'rails_helper'
 
RSpec.describe "Recipes", type: :request do
  describe '#create' do
    let(:recipe_params) { { recipe: { title: 'recipe title',
                            ingredient: '材料',
                            duration: 30,
                            cost: 1000 } } }

    context 'when you have not logged in' do
      it 'does not register a recipe' do
        expect {
          post recipes_path, params: recipe_params
        }.to_not change(Recipe, :count)
      end
 
      it 'redirects to login page' do
        post recipes_path, params: recipe_params
        expect(response).to redirect_to login_path
      end
    end
  end
 
  describe '#destroy' do
    let(:user) { FactoryBot.create(:user) }
 
    before do
      @recipe = FactoryBot.create(:most_recent)
    end
 
    context "when you try to delete another user's recipe" do
      before do
        log_in user
      end
 
      it 'does not remove' do
        expect {
          delete recipe_path(@recipe)
        }.to_not change(Recipe, :count)
      end
 
      it 'redirects to root path' do
        delete recipe_path(@recipe)
        expect(response).to redirect_to root_path
      end
    end
 
    context 'when you have not logged in' do
      it 'does not remove' do
        expect {
          delete recipe_path(@recipe)
        }.to_not change(Recipe, :count)
      end
 
      it 'redirects to root path' do
        delete recipe_path(@recipe)
        expect(response).to redirect_to login_path
      end
    end
  end
end