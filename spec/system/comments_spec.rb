require 'rails_helper'
 
RSpec.describe "Comments", type: :system do
  before do
    driven_by(:rack_test)
    @recipe = FactoryBot.create(:recipe, :with_comments)
  end

  describe 'comments' do
    it 'can be seen ' do
      visit recipe_path(@recipe)
      comments_wrapper =
      within 'ul.comments__list' do
        find_all('li.comments__item')
      end
      expect(comments_wrapper.size).to eq 5
    end

    context 'when you have not logged in' do
      it 'can be added' do
        user = FactoryBot.create(:user)
        log_in user
        visit recipe_path(@recipe)
        expect(page).to have_selector 'div.modalBtn'

        click_button 'コメントを追加'
        expect(page).to have_content 'コメントを投稿する'

        expect{
          fill_in 'コメント', with: 'コメントを追加します'
          click_button 'コメントを投稿する'
        }.to change(Comment, :count).by 1
      end
    end

    context 'when you have logged in' do
      it 'does not display a comment button' do
        visit recipe_path(@recipe)
        expect(page).to_not have_selector 'div.modalBtn'
      end
    end

    context 'when you are a correct user' do
      it 'can be deleted' do
        user = FactoryBot.create(:user)
        log_in user
        visit recipe_path(@recipe)
        click_button 'コメントを追加'
        fill_in 'コメント', with: 'コメントを追加します'
        click_button 'コメントを投稿する'

        visit recipe_path(@recipe)
        expect(page).to have_selector 'span.comments__delete'

        expect{
          click_link 'コメントを削除'
        }.to change(Comment, :count).by -1
      end
    end

    context 'when you are an incorrect user' do
      it 'cannot be deleted' do
        user = FactoryBot.create(:user)
        log_in user
        visit recipe_path(@recipe)
        click_button 'コメントを追加'
        fill_in 'コメント', with: 'コメントを追加します'
        click_button 'コメントを投稿する'

        click_link 'ログアウト'

        other_user = FactoryBot.create(:other_user)
        log_in other_user

        visit recipe_path(@recipe)
        expect(page).to_not have_selector 'span.comments__delete'
      end
    end
  end
end