require 'rails_helper'

RSpec.describe Favorite, type: :model do
  let(:favorite) {FactoryBot.create(:favorite)}

  it 'is invalid without a user_id' do
    favorite.user_id = nil
    expect(favorite).to_not be_valid
  end

  it 'is invalid without a recipe_id' do
    favorite.recipe_id = nil
    expect(favorite).to_not be_valid
  end

  describe '#favorites' do
    let(:recipe_by_user1) {FactoryBot.create(:recipe_by_user1)}
    let(:recipe_by_user2) {FactoryBot.create(:recipe_by_user2)}
    let(:user1){recipe_by_user1.user}

    it 'removes the favorites of the user if the posting user is deleted' do
      user1.favorite(recipe_by_user2)
      expect {
        user1.destroy
      }.to change(Favorite, :count).by -1
    end
  end
end
