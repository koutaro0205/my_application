require 'rails_helper'
 
RSpec.describe "Layouts", type: :system do
  before do
    driven_by(:rack_test)
  end
 
  let(:user) { FactoryBot.create(:user) }
 
  describe 'header' do
    context 'when you have logged in' do
      before do
        log_in user
        visit root_path
      end
 
      it 'transitions to root when you click title' do
        click_link 'ZuboRecipes'
        expect(page.current_path).to eq root_path
      end
 
      it 'transitions to root when you click ホーム' do
        click_link 'ホーム'
        expect(page.current_path).to eq root_path
      end

      it 'transitions to root when you click ログアウト' do
        click_link 'ログアウト'
        expect(page.current_path).to eq root_path
      end
 
      context 'Dropdown' do
        before do
          # click_link "#{user.name}"
          find(".dropdown__menu").click
        end

        it 'transitions to profile page when you click 登録情報' do
          click_link '登録情報'
          expect(page.current_path).to eq user_path(user)
        end
 
        it 'transitions to edit page when you click ユーザー設定' do
          click_link 'ユーザー設定'
          expect(page.current_path).to eq edit_user_path(user)
        end

        it 'transitions to users page when you click ユーザー一覧' do
          click_link 'ユーザー一覧'
          expect(page.current_path).to eq users_path
        end
      end
    end
 
    context 'when you have not logged in' do
      before do
        visit root_path
      end
 
      it 'transitions to root when you click ホーム' do
        click_link 'ホーム'
        expect(page.current_path).to eq root_path
      end
 
      it 'transitions to login page when you click ログイン' do
        click_link 'ログイン'
        expect(page.current_path).to eq login_path
      end

      it 'transitions to login page when you click ユーザー登録' do
        click_link 'ユーザー登録'
        expect(page.current_path).to eq signup_path
      end
    end
  end

  describe 'footer' do
    before do
      visit root_path
    end

    it 'transitions to root when you click ホームへ戻る' do
      click_link 'ホームへ戻る'
      expect(page.current_path).to eq root_path
    end
  end
end