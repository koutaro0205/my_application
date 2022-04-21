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
      before do
        FactoryBot.send(:user_with_posts, posts_count: 35)
        @user = Recipe.first.user
        @user.password = 'password'
        log_in @user
        visit root_path
      end

      # it 'displays 6 latest posts'
      # it 'displays 6 posts of following users'
      # it 'displays 6 popular posts'
    end
  end
end

