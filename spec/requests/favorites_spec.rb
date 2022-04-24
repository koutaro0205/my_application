require 'rails_helper'

RSpec.describe "Favorites", type: :request do
  let(:recipe_by_user1) {FactoryBot.create(:recipe_by_user1)}
  let(:recipe_by_user2) {FactoryBot.create(:recipe_by_user2)}
  let(:user1) {recipe_by_user1.user}

  describe 'POST /favorites #create' do
    context 'when you have logged in' do
      it 'increases your favorite recipe by one' do
        log_in user1
        expect {
          post favorites_path, params: { recipe_id: recipe_by_user2.id }
        }.to change(Favorite, :count).by 1
      end
      it 'can also be registered with Ajax' do
        log_in user1
        expect {
          post favorites_path, params: { recipe_id: recipe_by_user2.id }, xhr: true
        }.to change(Favorite, :count).by 1
      end
    end
    context 'when you have not logged in' do
      it 'redirects to login page' do
        post favorites_path
        expect(response).to redirect_to login_path
      end
      it 'cannot be registered' do
        expect {
          post favorites_path
        }.to_not change(Favorite, :count)
      end
    end
  end

  describe 'DELETE /favorite #destory' do
    context 'when you have logged in' do
      it 'decreases your favorite recipe by one' do
        log_in user1
        user1.favorite(recipe_by_user2)
        favorite = user1.favorites.find_by(recipe_id: recipe_by_user2.id)
        expect {
          delete favorite_path(favorite)
        }.to change(Favorite, :count).by -1
      end

      it 'can also be registered with Ajax' do
        log_in user1
        user1.favorite(recipe_by_user2)
        favorite = user1.favorites.find_by(recipe_id: recipe_by_user2.id)
        expect {
          delete favorite_path(favorite), xhr: true
        }.to change(Favorite, :count).by -1
      end
    end

    context 'when you have not logged in' do
      it 'redirects to login page' do
        user1.favorite(recipe_by_user2)
        favorite = user1.favorites.find_by(recipe_id: recipe_by_user2.id)
        delete favorite_path(favorite)
        expect(response).to redirect_to login_path
      end

      it 'cannot be registered' do
        user1.favorite(recipe_by_user2)
        favorite = user1.favorites.find_by(recipe_id: recipe_by_user2.id)
        expect {
          delete favorite_path(favorite)
        }.to_not change(Favorite, :count)
      end
    end
  end
end