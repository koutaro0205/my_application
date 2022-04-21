require 'rails_helper'

RSpec.describe 'Relationships', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:other_user) }
  describe '#create' do
    it 'increases the number of users you are following by 1' do
      log_in user
      expect {
        post relationships_path, params: { followed_id: other_user.id }
      }.to change(Relationship, :count).by 1
    end

    it 'can also be registered with Ajax' do
      log_in user
      expect {
        post relationships_path, params: { followed_id: other_user.id }, xhr: true
      }.to change(Relationship, :count).by 1
    end

    context 'when you have not logged in' do
      it 'redirects to login page' do
        post relationships_path
        expect(response).to redirect_to login_path
      end

      it 'cannot be registered' do
        expect {
          post relationships_path
        }.to_not change(Relationship, :count)
      end
    end
  end

  describe '#destroy' do
    it 'decreases the number of users you are following by 1' do
      log_in user
      user.follow(other_user)
      relationship = user.active_relationships.find_by(followed_id: other_user.id)
      expect {
        delete relationship_path(relationship)
      }.to change(Relationship, :count).by -1
    end
   
    it 'can also be registered with Ajax' do
      log_in user
      user.follow(other_user)
      relationship = user.active_relationships.find_by(followed_id: other_user.id)
      expect {
        delete relationship_path(relationship), xhr: true
      }.to change(Relationship, :count).by -1
    end
  end
end