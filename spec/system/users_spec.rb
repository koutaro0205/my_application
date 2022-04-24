require 'rails_helper'

RSpec.describe "Users", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe '#create' do
    context 'when the value is invalid' do
      it 'displays area for error messages draws' do
        visit signup_path
        fill_in '名前', with: ''
        fill_in 'メールアドレス', with: 'tester@invlid'
        fill_in 'パスワード', with: 'inv'
        fill_in 'パスワード（確認）', with: 'inv'
        click_button 'ユーザー登録'

        expect(page).to have_selector 'div.error_explanation'
        expect(page).to have_selector 'div.field_with_errors'
      end
    end
  end

  describe '#index' do
    let!(:admin) { FactoryBot.create(:user) }
    let!(:not_admin) { FactoryBot.create(:other_user) }

    it 'displays a delete link if it is an admin user' do
      log_in admin
      visit users_path
      expect(page).to have_link 'ユーザーを削除（管理者権限）'
    end

    it 'does not show the delete link unless it is an admin user' do
      log_in not_admin
      visit users_path
      expect(page).to_not have_link 'ユーザーを削除（管理者権限）'
    end
  end

  describe '#edit' do
    it 'can attach an image' do
      user = FactoryBot.create(:user)
      log_in user
      click_link 'ユーザー設定'

      attach_file "user[image]", "#{Rails.root}/spec/files/testImage.jpeg"
      click_button '登録情報を更新'

      attached_user = User.first
      expect(attached_user.image).to be_attached
    end
  end
end