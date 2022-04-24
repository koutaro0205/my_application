require 'rails_helper'
 
RSpec.describe "Favorites", type: :system do
  before do
    driven_by(:rack_test)
    @user = FactoryBot.send(:create_favorites)
    log_in @user
  end

  describe 'favorites' do
    it 'displays a link to the favorite recipes' do
      visit favorite_recipes_user_path(@user)
      expect(@user.favorite_recipes).to_not be_empty
      @user.favorite_recipes.each do |recipe|
        expect(page).to have_link recipe.title, href: recipe_path(recipe)
      end
    end
  end
end