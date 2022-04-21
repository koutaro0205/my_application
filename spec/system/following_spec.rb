require 'rails_helper'
 
RSpec.describe "Following", type: :system do
  before do
    driven_by(:rack_test)
    @user = FactoryBot.send(:create_relationships)
    log_in @user
  end
 
  describe 'following and followers' do
    it 'displays a link to the user you are following' do
      visit following_user_path(@user)
      expect(@user.following).to_not be_empty
      @user.following.each do |user|
        expect(page).to have_link user.name, href: user_path(user)
      end
    end
  end
 
  describe 'followers' do
    it 'displays a link to the users who are following you' do
      visit followers_user_path(@user)
      expect(@user.followers).to_not be_empty
      @user.followers.each do |user|
        expect(page).to have_link user.name, href: user_path(user)
      end
    end
  end
end