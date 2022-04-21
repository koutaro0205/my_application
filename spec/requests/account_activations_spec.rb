require 'rails_helper'

RSpec.describe "AccountActivations", type: :request do
  describe '/account_activations/{id}/edit' do
    before do
      post users_path, params: { user: { name: 'Example User',
                                        email: 'user@example.com',
                                        password: 'password',
                                        password_confirmation: 'password' } }
      @user = controller.instance_variable_get('@user')
      #createのUser.newで生成したインスタンス（変数）を取得・使用
    end

    context 'When the token and URL are valid' do
      it 'activates when the URL is clicked' do
        get edit_account_activation_path(@user.activation_token, email: @user.email)
        @user.reload
        expect(@user).to be_activated
      end

      it 'puts you logged in' do
        get edit_account_activation_path(@user.activation_token, email: @user.email)
        expect(logged_in?).to be_truthy
      end

      it 'redirects to profile page' do
        get edit_account_activation_path(@user.activation_token, email: @user.email)
        expect(response).to redirect_to user_path(@user)
      end
    end

    context 'When the token and URL are invalid' do
      it 'does not log in if the token is incorrect' do
        get edit_account_activation_path('invalid token', email: @user.email)
        expect(logged_in?).to be_falsey
      end

      it 'does not log in if the email is incorrect' do
        get edit_account_activation_path(@user.activation_token, email: 'wrong')
        expect(logged_in?).to be_falsey
      end
    end
  end
end