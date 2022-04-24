require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /signup #new" do
    it "responds successfully" do
      get signup_path
      expect(response).to have_http_status "200"
    end

    it 'includes ユーザー登録 | ZuboRecipes' do
      get signup_path
      expect(response.body).to include full_title('ユーザー登録')
    end
  end

  describe 'GET /users #index' do
    it 'redirects to the login page if you are not a logged-in user' do
      get users_path
      expect(response).to redirect_to login_path
    end

    describe 'pagination' do
      before do
        30.times do
          FactoryBot.create(:continuous_users)
        end
        user = FactoryBot.create(:user)
        log_in user
        get users_path
      end

      it 'includes div.pagination' do
        expect(response.body).to include '<div role="navigation" class="pagination">'
      end

      it 'includes per-user links' do
        User.paginate(page: 1).each do |user|
          expect(response.body).to include "<a href=\"#{user_path(user)}\">"
        end
      end
    end
  end

  describe 'get /users/{id} #show' do
    it 'redirects to root path if it is not enabled' do
      user = FactoryBot.create(:user)
      not_activated_user = FactoryBot.create(:not_activated_user)
      log_in user
      get user_path(not_activated_user)
      expect(response).to redirect_to root_path
    end
  end

  describe 'POST /users #create' do
    it "when the value is an invalid" do
      expect {
        post users_path, params: { user: { name: '',
                                            email: 'user@invlid',
                                            password: 'foo',
                                            password_confirmation: 'bar' } }
      }.to_not change(User, :count)
    end

    context 'when the value is invalid' do
        before do
          ActionMailer::Base.deliveries.clear
        end

        let(:user_params) { { user: { name: 'Example User',
                                      email: 'user@example.com',
                                      password: 'password',
                                      password_confirmation: 'password',
                                        } } }

        it 'registers a user' do
          expect {
            post users_path, params: user_params
          }.to change(User, :count).by 1
        end

        it 'redirects to' do
          post users_path, params: user_params
          user = User.last
          expect(response).to redirect_to root_path
        end

        it 'displays a flash message' do
          post users_path, params: user_params
          expect(flash).to be_any
        end

        it 'contains one email sent' do
          post users_path, params: user_params
          expect(ActionMailer::Base.deliveries.size).to eq 1
        end
  
        it 'does not activate at registration' do
          post users_path, params: user_params
          expect(User.last).to_not be_activated
        end

      # it 'is not logged in' do
      #   user = FactoryBot.create(:user)
      #   post login_path, params: { session: { email: user.email,
      #                                       password: user.password } }
      #   expect(logged_in?).to_not be_truthy
      # end

    end
  end

  describe 'get /users/{id}/edit' do
    let(:user) { FactoryBot.create(:user) }

    it 'includes ユーザー設定 | ZuboRecipes' do
      log_in user
      get edit_user_path(user)
      expect(response.body).to include full_title('ユーザー設定')
    end

    context 'when you have not logged in' do
      it 'does not empty flash messages' do
        get edit_user_path(user)
        expect(flash).to_not be_empty #FM=「ログインしなさい」
      end

      it 'redirects to login page' do
        get edit_user_path(user)
        expect(response).to redirect_to login_path
      end

      it 'redirect to the edit page when you log in' do
        get edit_user_path(user)
        log_in user
        expect(response).to redirect_to edit_user_path(user) # friendly forward
      end
    end

    context 'when you are other user' do
      let(:other_user) { FactoryBot.create(:user) }

      it 'empty the flash message' do
        log_in user
        get edit_user_path(other_user)
        expect(flash).to be_empty
      end

      it 'redirects to root_path' do
        log_in user
        get edit_user_path(other_user)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'PATCH /users' do
    let!(:user) { FactoryBot.create(:user) }

    it 'cannot update the admin attribute' do
      log_in user = FactoryBot.create(:other_user)
      expect(user).to_not be_admin
 
      patch user_path(user), params: { user: { password: 'password',
                                                password_confirmation: 'password',
                                                admin: true } }
      user.reload
      expect(user).to_not be_admin
    end

    context 'when the value is invalid' do
      before do
        log_in user
        patch user_path(user), params: { user: { name: '',
                                                  email: 'foo@invlid',
                                                  password: 'foo',
                                                  password_confirmation: 'bar' } }
      end
      it 'cannot update' do
        user.reload
        expect(user.name).to_not eq ''
        expect(user.email).to_not eq ''
        expect(user.password).to_not eq 'foo'
        expect(user.password_confirmation).to_not eq 'bar'
      end

      it 'displays edit page after update action' do
        expect(response.body).to include full_title('ユーザー設定')
      end

      it 'displays an error message' do
        expect(response.body).to include '4つの入力内容が正しくありません。'
      end
    end

    context 'when the value is valid' do
      before do
        log_in user
        @name = 'Foo Bar'
        @email = 'foo@bar.com'
        patch user_path(user), params: { user: { name: @name,
                                                  email: @email,
                                                  password: '',
                                                  password_confirmation: '' } }
      end

      it 'can update' do
        user.reload
        expect(user.name).to eq @name
        expect(user.email).to eq @email
      end

      it 'redirects to Users#show' do
        expect(response).to redirect_to user
      end

      it 'displays a flash message' do
        expect(flash).to be_any
      end
    end

    context 'when you have not logged in' do
      it 'does not empty flash messages' do
        patch user_path(user), params: { user: { name: user.name,
          email: user.email } }
        expect(flash).to_not be_empty
      end

      it 'redirects to login page' do
        patch user_path(user), params: { user: { name: user.name,
          email: user.email } }
        expect(response).to redirect_to login_path
      end
    end

    context 'when you are other user' do
      let(:other_user) { FactoryBot.create(:other_user) } #

      before do
        log_in user
        patch user_path(other_user), params: { user: { name: other_user.name,
                                                        email: other_user.email } }
      end

      it 'empty the flash message' do
        expect(flash).to be_empty
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

  end

  describe 'DELETE /users/{id}' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:other_user) { FactoryBot.create(:other_user) }

    context 'when you have not logged in' do
      it 'cannot delete' do
        expect {
          delete user_path(user)
        }.to_not change(User, :count)
      end

      it 'redirects to login page' do
        delete user_path(user)
        expect(response).to redirect_to login_path
      end
    end
   
    context 'when you are not an admin user' do
      it 'cannot delete' do
        log_in other_user
        expect {
          delete user_path(user)
        }.to_not change(User, :count)
      end
   
      it 'redirects to root path' do
        log_in other_user
        delete user_path(user)
        expect(response).to redirect_to root_path
      end

      it 'displays a flash message' do
        log_in other_user
        delete user_path(user)
        expect(flash).to_not be_empty #FM=権限がありません
      end
    end

    context 'when you have logged in as an admin user' do
      it 'can delete' do
        log_in user
        expect {
          delete user_path(other_user)
        }.to change(User, :count).by -1
      end

      it 'displays a flash message' do
        log_in user
        delete user_path(other_user)
        expect(flash).to_not be_empty #FM=ユーザーを削除しました
      end
    end
  end

  describe 'GET /users/{id}/following' do
    let(:user) { FactoryBot.create(:user) }
 
    it '未ログインならログインページにリダイレクトすること' do
      get following_user_path(user)
      expect(response).to redirect_to login_path
    end
  end
 
  describe 'GET /users/{id}/followers' do
    let(:user) { FactoryBot.create(:user) }
 
    it '未ログインならログインページにリダイレクトすること' do
      get followers_user_path(user)
      expect(response).to redirect_to login_path
    end
  end

end
