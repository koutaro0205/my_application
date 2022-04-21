require 'rails_helper'
 
RSpec.describe "Sessions", type: :system do
  before do
    driven_by(:rack_test)
  end
 
  describe '#new' do
    context 'when the value is invalid' do
      it 'displays a flash message' do
        visit login_path
 
        fill_in 'メールアドレス', with: ''
        fill_in 'パスワード', with: ''
        click_button 'ログイン'

        expect(page).to have_selector 'div.alert.alert-danger'

        visit root_path
        expect(page).to_not have_selector 'div.alert.alert-danger'
      end
    end

    context '有効な値の場合' do
      let(:user) { FactoryBot.create(:user) }

      it 'displays a page for logged-in users' do
        visit login_path

        fill_in 'メールアドレス', with: user.email
        fill_in 'パスワード', with: user.password
        click_button 'ログイン'

        expect(page).to_not have_selector "a[href=\"#{login_path}\"]"
        expect(page).to have_selector "a[href=\"#{logout_path}\"]"
        expect(page).to have_selector "a[href=\"#{user_path(user)}\"]"
        expect(page).to have_selector "a[href=\"#{edit_user_path(user)}\"]"
        expect(page).to have_selector "a[href=\"#{users_path}\"]"
      end
    end
  end
end