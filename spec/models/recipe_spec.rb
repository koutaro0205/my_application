require 'rails_helper'
 
RSpec.describe Recipe, type: :model do
  let(:user) { FactoryBot.create(:user) }
  let(:recipe) { FactoryBot.build(:recipe, user_id: user.id) }
 
  it 'is valid' do
    expect(recipe).to be_valid
  end

  it 'is invalid without a user_id' do
    recipe.user_id = nil
    expect(recipe).to_not be_valid
  end

  it 'is invalid without a title' do
    recipe.title = nil
    expect(recipe).to_not be_valid
  end

  it "is invalid unless the number of characters in the title is 50 or less" do
    recipe.title = "a" * 51
    recipe.valid?
    expect(recipe.errors[:title]).to include("は50文字以内で入力してください")
  end

  it 'is invalid without a ingredient' do
    recipe.ingredient = nil
    expect(recipe).to_not be_valid
  end

  it 'is invalid without the duration' do
    recipe.duration = nil
    expect(recipe).to_not be_valid
  end

  it 'is invalid without a cost' do
    recipe.cost = nil
    expect(recipe).to_not be_valid
  end

  it "can have many comments" do
    recipe_with = FactoryBot.create(:recipe, :with_comments)
    expect(recipe_with.comments.length).to eq 5
  end

  it "can have many favorites" do
    recipe = FactoryBot.create(:recipe, :with_favorites)
    expect(recipe.favorites.length).to eq 5
  end

  it 'sorts from newest post' do
    FactoryBot.send(:user_with_posts)
    expect(FactoryBot.create(:most_recent)).to eq Recipe.first
  end

  it 'removes the recipe of the user if the posting user is deleted' do
    recipe = FactoryBot.create(:most_recent)
    user = recipe.user
    expect {
      user.destroy
    }.to change(Recipe, :count).by -1
  end
end
