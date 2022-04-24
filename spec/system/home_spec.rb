require 'rails_helper'

RSpec.describe "Home", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe 'root' do
    it 'includes some links in header and footer' do
      visit root_path
      link_to_root = page.find_all("a[href=\"#{root_path}\"]")

      expect(link_to_root.size).to eq 3
      expect(page).to have_link 'ログイン', href: login_path
      expect(page).to have_link 'ユーザー登録', href: signup_path
    end
    
    context 'when you have logged in' do

      it 'displays 6 latest recipes' do
        FactoryBot.send(:user_with_posts, posts_count: 10)
        @user = Recipe.first.user
        @user.password = 'password'
        log_in @user
        visit root_path

        posts_wrapper =
        within 'ul.recipes-latest' do
          find_all('li.recipeCard')
        end
        expect(posts_wrapper.size).to eq 6
      end

      it 'displays 6 recipes with many favorites' do
        @user = FactoryBot.send(:create_favorites)
        log_in @user
        visit root_path

        posts_wrapper =
        within 'ul.recipes-favorites' do
          find_all('li.recipeCard')
        end
        expect(posts_wrapper.size).to eq 6
      end

      it 'displays 6 recipes of following users' do
        @user = FactoryBot.send(:create_following_recipes)
        log_in @user
        visit root_path

        posts_wrapper =
        within 'ul.recipes-following' do
          find_all('li.recipeCard')
        end
        expect(posts_wrapper.size).to eq 6
      end

      it 'displays a total of 18 recipes' do
        @user = FactoryBot.send(:create_recipe_lists)
        log_in @user
        visit root_path

        posts_wrapper = find_all('li.recipeCard')
        expect(posts_wrapper.size).to eq 18
      end
    end
  end
end

