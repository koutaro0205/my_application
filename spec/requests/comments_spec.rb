require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let!(:user) {FactoryBot.create(:user)}
  let!(:recipe) {FactoryBot.create(:recipe, user_id: user.id)}
  describe "POST /recipes/{recipe_id}/comments #create" do
    let(:comment_params) { { comment: { content: "content", recipe_id: recipe.id } } }
    context 'when you have logged in' do
      before do
        log_in user
      end

      it 'can add comments to your own posts' do
        expect{
          post recipe_comments_path(recipe), params: comment_params
        }.to change(Comment, :count).by 1
      end

      it "can add comments to other users' posts" do
        other_user_recipe = FactoryBot.create(:most_recent)
        expect{
          post recipe_comments_path(other_user_recipe), params: comment_params
        }.to change(Comment, :count).by 1
      end
    end

    context 'when you have not logged in' do
      it 'cannot add comments to your own posts' do
        expect{
          post recipe_comments_path(recipe), params: comment_params
        }.to_not change(Comment, :count)
      end

      it "cannot add comments to other users' posts" do
        other_user_recipe = FactoryBot.create(:most_recent)
        expect{
          post recipe_comments_path(other_user_recipe), params: comment_params
        }.to_not change(Comment, :count)
      end
    end
  end

  describe "DELETE /recipes/{recipe_id}/comments #destroy" do
    let!(:comment) { FactoryBot.create(:comment, recipe_id: recipe.id, user_id: user.id) }
    context 'when you have logged in' do
      it 'can delete' do
        log_in user
        expect{
          delete recipe_comment_path(recipe, comment)
        }.to change(Comment, :count).by -1
      end
    end
    context 'when you have not logged in' do
      it 'cannot delete' do
        expect{
          delete recipe_comment_path(recipe, comment)
        }.to_not change(Comment, :count)
      end
    end
    context "when you try to delete another user's comment" do
      before do
        @other_comment = FactoryBot.create(:comment)
        log_in user
      end

      it 'cannot delete' do
        expect{
          delete recipe_comment_path(recipe, @other_comment)
        }.to_not change(Comment, :count)
      end

      it 'redirects to root path' do
        delete recipe_comment_path(recipe, @other_comment)
        expect(response).to redirect_to root_path
      end
    end
  end
end