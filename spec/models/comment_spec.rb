require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) {FactoryBot.create(:comment)}

  it 'is invalid without a user_id' do
    comment.user_id = nil
    expect(comment).to_not be_valid
  end

  it 'is invalid without a recipe_id' do
    comment.recipe_id = nil
    expect(comment).to_not be_valid
  end

  it 'is invalid without a content' do
    comment.content = nil
    expect(comment).to_not be_valid
  end

  it "is invalid unless the number of characters in the content of comments is 140 or less" do
    comment = FactoryBot.build(:comment, content: "a" * 141)
    comment.valid?
    expect(comment.errors[:content]).to include("は140文字以内で入力してください")
  end

  it 'removes the comment of the recipe if the recipe is deleted' do
    new_comment = FactoryBot.create(:comment)
    recipe = new_comment.recipe
    expect{
      recipe.destroy
    }.to change(Comment, :count).by -1
  end

  it 'removes the comment of the user if the user is deleted' do
    new_comment = FactoryBot.create(:comment)
    user = new_comment.user
    expect{
      user.destroy
    }.to change(Comment, :count).by -1
  end
end
