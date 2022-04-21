require 'rails_helper'
 
RSpec.describe "Recipes", type: :system do
  before do
    driven_by(:rack_test)
  end
 
  describe 'Users#show' do
    before do
      FactoryBot.send(:user_with_posts, posts_count: 35)
      @user = Recipe.first.user
      @user.password = 'password'
      log_in @user
      visit user_path @user
    end
 
    it 'displays 30 recipes' do
      posts_wrapper =
        within 'ul.recipes' do
          find_all('li')
        end
      expect(posts_wrapper.size).to eq 30
    end
 
    it 'displays the pagination wrapper tag' do
      expect(page).to have_selector 'div.pagination'
    end
 
    it 'displays the recipe title in the page' do
      @user.recipes.paginate(page: 1).each do |recipe|
        expect(page).to have_content recipe.title
      end
    end

    it 'only displays pagination in one place' do
      pagination = find_all('div.pagination')
      expect(pagination.size).to eq 1
    end

    it 'displays 投稿数 35' do
      expect(page).to have_content '投稿数 35'
    end

    it 'will be displayed as 投稿数 0 if it is 0, and it will be displayed as 投稿数 0 if it is 1' do
      @user.recipes.destroy_all
      visit user_path @user
      expect(page).to have_content '投稿数 0'

      visit new_recipe_path
      fill_in "レシピタイトル", with: 'レシピタイトル'
      fill_in '材料', with: '材料'
      fill_in '所要時間(分)', with: 10
      fill_in '値段(円)', with: 300
      click_button 'レシピを投稿する'
      visit user_path @user
      expect(page).to have_content '投稿数 1'
    end
  end

  describe 'recipes#index' do
    it 'displays the pagination wrapper tag' do
      FactoryBot.send(:user_with_posts, posts_count: 35)
      user = Recipe.first.user
      log_in user
      visit recipes_path
      expect(page).to have_selector 'div.pagination'
    end
  end

  describe 'recipes#create' do
    context 'when an valid transmission is made' do
      it 'can post' do
        user = FactoryBot.create(:user)
        log_in user
        visit new_recipe_path
        expect {
          fill_in 'レシピタイトル', with: 'レシピタイトル'
          fill_in '材料', with: '材料'
          fill_in '所要時間(分)', with: 10
          fill_in '値段(円)', with: 300
          click_button 'レシピを投稿する'
        }.to change(Recipe, :count).by 1

        expect(page).to have_content 'レシピタイトル'
      end
    end

    context 'when an invalid transmission is made' do
      it 'does not post if title, material, time, price is empty' do
        user = FactoryBot.create(:user)
        log_in user
        visit new_recipe_path
        fill_in 'レシピタイトル', with: ''
        fill_in '材料', with: '材料'
        fill_in '所要時間(分)', with: 10
        fill_in '値段(円)', with: 300
        click_button 'レシピを投稿する'
        expect(page).to have_selector 'div.error_explanation'

        visit new_recipe_path
        fill_in 'レシピタイトル', with: 'レシピタイトル'
        fill_in '材料', with: ''
        fill_in '所要時間(分)', with: 10
        fill_in '値段(円)', with: 300
        click_button 'レシピを投稿する'
        expect(page).to have_selector 'div.error_explanation'

        visit new_recipe_path
        fill_in 'レシピタイトル', with: 'レシピタイトル'
        fill_in '材料', with: ''
        fill_in '所要時間(分)', with: ''
        fill_in '値段(円)', with: 300
        click_button 'レシピを投稿する'
        expect(page).to have_selector 'div.error_explanation'

        visit new_recipe_path
        fill_in 'レシピタイトル', with: 'レシピタイトル'
        fill_in '材料', with: ''
        fill_in '所要時間(分)', with: 10
        fill_in '値段(円)', with: ''
        click_button 'レシピを投稿する'
        expect(page).to have_selector 'div.error_explanation'
      end
    end

    it 'can attach an image' do
      user = FactoryBot.create(:user)
      log_in user
      visit new_recipe_path
      expect {
        fill_in 'レシピタイトル', with: 'レシピタイトル'
        fill_in '材料', with: '材料'
        fill_in '所要時間(分)', with: 10
        fill_in '値段(円)', with: 300
        attach_file "Image", "#{Rails.root}/spec/files/testImage.jpeg"
        click_button 'レシピを投稿する'
      }.to change(Recipe, :count).by 1

      attached_post = Recipe.first
      expect(attached_post.image).to be_attached
    end
  end

  describe 'recipes#show' do
    before do
      @user = FactoryBot.create(:user)
      @recipe = FactoryBot.create(:recipe, user_id: @user.id)
      log_in @user
      visit recipe_path(@recipe)
    end

    it 'can delete a recipe'  do
      expect(page).to have_content 'レシピを削除する'

      expect {
        click_link 'レシピを削除する'
      }.to change(Recipe, :count).by -1
      expect(page).to have_content 'レシピを削除しました'
      expect(page).to_not have_content 'レシピタイトル'
    end

    it 'cannot delete a recipe'  do
      expect(page).to have_content 'レシピを編集する'

      click_link 'レシピを編集する'
      expect(page.current_path).to eq edit_recipe_path(@recipe)
    end

    it "doesn't show the delete button in other users' profiles" do
      @other_user = FactoryBot.create(:other_user)
      visit user_path(@other_user)
      expect(page).to_not have_link 'レシピを削除する'
    end

    it "doesn't show the edit button in other users' profiles" do
      @other_user = FactoryBot.create(:other_user)
      visit user_path(@other_user)
      expect(page).to_not have_link 'レシピを編集する'
    end
  end
end