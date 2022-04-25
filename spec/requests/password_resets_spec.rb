require 'rails_helper'
 
RSpec.describe "PasswordResets", type: :request do
  let(:user) { FactoryBot.create(:user) }
 
  before do
    ActionMailer::Base.deliveries.clear
  end
 
  describe '#new' do
    it 'displays an input tag for the name attribute called password_reset [email]' do
      get new_password_reset_path
      expect(response.body).to include "name=\"password_reset[email]\""
    end
  end
 
  describe '#create' do
    it 'displays a flash message when it is an invalid email address' do
      post password_resets_path, params: { password_reset: { email: '' } }
      expect(flash).to_not be_empty
    end
 
    context 'when it is an valid email address' do
      it 'changes reset_digest' do
        post password_resets_path, params: { password_reset: { email: user.email } }
        expect(user.reset_digest).to_not eq user.reload.reset_digest
      end
 
      it 'increases one email' do
        expect {
          post password_resets_path, params: { password_reset: { email: user.email } }
        }.to change(ActionMailer::Base.deliveries, :count).by 1
      end
 
      it 'includes a flash message' do
        post password_resets_path, params: { password_reset: { email: user.email } }
        expect(flash).to_not be_empty
      end
 
      it 'redirects to root path' do
        post password_resets_path, params: { password_reset: { email: user.email } }
        expect(response).to redirect_to root_path
      end
    end
  end
 
  describe '#edit' do
    before do
      post password_resets_path, params: { password_reset: { email: user.email } }
      @user = controller.instance_variable_get('@user')
    end
 
    it 'displays the email address in a hidden field if it has both an email address and a token valid' do
      get edit_password_reset_path(@user.reset_token, email: @user.email)
      expect(response.body).to include "<input type=\"hidden\" name=\"email\" id=\"email\" value=\"#{@user.email}\" autocomplete=\"off\" />"
    end
 
    it 'redirects to root if the email address is wrong' do
      get edit_password_reset_path(@user.reset_token, email: '')
      expect(response).to redirect_to root_path
    end
 
    it 'redirects to root path if it is an invalid user' do
      @user.toggle!(:activated)
      get edit_password_reset_path(@user.reset_token, email: @user.email)
      expect(response).to redirect_to root_path
    end
 
    it 'redirects to root path if it is an invalid token' do
      get edit_password_reset_path('wrong token', email: @user.email)
      expect(response).to redirect_to root_path
    end

    it 'redirects to new password_reset path' do
      @user.update_attribute(:reset_sent_at, 3.hours.ago)
      get edit_password_reset_path(@user.reset_token, email: @user.email)
      expect(response).to redirect_to new_password_reset_path
    end
  end
 
  describe '#update' do
    before do
      post password_resets_path, params: { password_reset: { email: user.email } }
      @user = controller.instance_variable_get('@user')
    end
 
    context 'when the pasword is valid' do
      it 'puts you logged in' do
        patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                                user: { password: 'foobaz',
                                                                        password_confirmation: 'foobaz' } }
        expect(logged_in?).to be_truthy
      end
 
      it 'incudes a flash message' do
        patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                                user: { password: 'foobaz',
                                                                        password_confirmation: 'foobaz' } }
        expect(flash).to_not be_empty
      end
 
      it 'redirects to profile page' do
        patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                                user: { password: 'foobaz',
                                                                        password_confirmation: 'foobaz' } }
        expect(response).to redirect_to @user
      end

      it 'It makes reset_digest nil' do
        patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                                user: { password: 'foobaz',
                                                                        password_confirmation: 'foobaz' } }
        @user.reload
        expect(@user.reset_digest).to be_nil
      end
    end
 
    it 'displays an error message if the password and confirmation do not match' do
      patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                              user: { password: 'foobaz',
                                                                      password_confirmation: 'barquux' } }
      expect(response.body).to include "<div class=\"error_explanation\">"
    end
 
    it 'displays an error message if the password is empty' do
      patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                              user: { password: '',
                                                                      password_confirmation: '' } }
      expect(response.body).to include "<div class=\"error_explanation\">"
    end

    context 'when more than 2 hours have passed' do
      before do
        @user.update_attribute(:reset_sent_at, 3.hours.ago)
      end

      it 'redirects to new page' do
        patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                                user: { password: 'foobaz',
                                                                        password_confirmation: 'foobaz' } }
        expect(response).to redirect_to new_password_reset_path
      end

      it 'displays "再設定されたパスワードの有効期限が切れました"' do
        patch password_reset_path(@user.reset_token), params: { email: @user.email,
                                                                user: { password: 'foobaz',
                                                                        password_confirmation: 'foobaz' } }
        follow_redirect!
        expect(response.body).to include '再設定されたパスワードの有効期限が切れました'
      end
    end
  end
end