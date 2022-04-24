require 'rails_helper'
 
RSpec.describe "Recipes", type: :request do
  describe "GET /recipes #index" do
    it "responds successfully" do
      get recipes_path
      expect(response).to be_successful
    end

    it 'includes レシピ一覧 | ZuboRecipes' do
      get recipes_path
      expect(response.body).to include full_title('レシピ一覧')
    end

    describe 'pagination' do
      before do
        31.times do
          FactoryBot.create(:continuous_recipes)
        end
        # recipe = Recipe.last
        # user = FactoryBot.create(:user)
        # log_in user
        get recipes_path
      end

      it 'includes div.pagination' do
        expect(response.body).to include '<div role="navigation" class="pagination">'
      end

      it 'includes per-user links' do
        Recipe.paginate(page: 1).each do |recipe|
          expect(response.body).to include "<a href=\"#{recipe_path(recipe)}\">"
        end
      end
    end
  end

  describe "GET /recipes/{id} #show" do
    let(:recipe) {FactoryBot.create(:recipe)}
    it "responds successfully" do
      get recipe_path(recipe)
      expect(response).to be_successful
    end

    it 'includes recipe.title | ZuboRecipes' do
      get recipe_path(recipe)
      expect(response.body).to include full_title(recipe.title)
    end
  end

  describe "GET /recipes/new #new" do
    context "when you have not logged in" do
      it 'does not empty flash messages' do
        get new_recipe_path
        expect(flash).to_not be_empty #FM=「ログインしなさい」
      end

      it 'redirects to login page' do
        get new_recipe_path
        expect(response).to redirect_to login_path
      end

      it 'redirect to the edit page when you log in' do
        get new_recipe_path
        user = FactoryBot.create(:user)
        log_in user
        expect(response).to redirect_to new_recipe_path # friendly forward
      end
    end

    context "when you have logged in" do
      before do
        @user = FactoryBot.create(:user)
        log_in @user
      end

      it "responds successfully" do
        get new_recipe_path
        expect(response).to be_successful
      end

      it "includes レシピを投稿 | ZuboRecipes" do
        get new_recipe_path
        expect(response.body).to include full_title('レシピを投稿')
      end
    end
  end

  describe 'POST /recipes #create' do
    let(:recipe_params) { { recipe: { title: 'recipe title',
                            ingredient: '材料',
                            duration: 30,
                            cost: 1000 } } }

    context 'when you have not logged in' do
      it 'does not register a recipe' do
        expect {
          post recipes_path, params: recipe_params
        }.to_not change(Recipe, :count)
      end
 
      it 'redirects to login page' do
        post recipes_path, params: recipe_params
        expect(response).to redirect_to login_path
      end
    end

    context 'when you have not logged in' do
      before do
        @user = FactoryBot.create(:user)
        log_in @user
      end

      it "can post recipes" do
        expect {
          post recipes_path, params: recipe_params
        }.to change(Recipe, :count).by 1
      end
    end
  end

  describe 'GET /recipes/{id}/edit #edit' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:recipe) { FactoryBot.create(:recipe, user_id: user.id) }

    context "when you have not logged in" do
      it 'does not empty flash messages' do
        get edit_recipe_path(recipe)
        expect(flash).to_not be_empty #FM=「ログインしなさい」
      end

      it 'redirects to login page' do
        get edit_recipe_path(recipe)
        expect(response).to redirect_to login_path
      end

      it 'redirect to the edit page when you log in' do
        get edit_recipe_path(recipe)
        log_in user
        expect(response).to redirect_to edit_recipe_path(recipe) # friendly forward
      end
    end

    context "when you have logged in" do
      before do
        log_in user
      end

      it "responds successfully" do
        get edit_recipe_path(recipe)
        expect(response).to be_successful
      end

      it "includes レシピ編集 | ZuboRecipes" do
        get edit_recipe_path(recipe)
        expect(response.body).to include full_title('レシピ編集')
      end
    end
  end

  describe 'PATCH /recipes #update' do
    let!(:user) { FactoryBot.create(:user) }
    let!(:recipe) { FactoryBot.create(:recipe, user_id: user.id) }
    context 'when the value is invalid' do
      before do
        log_in user
        patch recipe_path(recipe), params: { recipe: { title: '',
                                              ingredient: '',
                                              duration: '',
                                              cost: '' } }
      end

      it 'cannot update' do
        recipe.reload
        expect(recipe.title).to_not eq ''
        expect(recipe.ingredient).to_not eq ''
        expect(recipe.duration).to_not eq ''
        expect(recipe.cost).to_not eq ''
      end

      it 'displays edit page after update action' do
        expect(response.body).to include full_title('レシピ編集')
      end

      it 'displays an error message' do
        expect(response.body).to include '4つの入力内容が正しくありません。'
      end
    end

    context 'when the value is valid' do
      before do
        log_in user
        @title = 'title'
        @ingredient = 'ingredient'
        @duration = 40
        @cost = 900
        patch recipe_path(recipe), params: { recipe: { title: @title,
                                                        ingredient: @ingredient,
                                                        duration: @duration,
                                                        cost: @cost } }
      end

      it 'can update' do
        recipe.reload
        expect(recipe.title).to eq @title
        expect(recipe.ingredient).to eq @ingredient
        expect(recipe.duration).to eq @duration
        expect(recipe.cost).to eq @cost
      end

      it 'redirects to recipes#show' do
        expect(response).to redirect_to recipe
      end

      it 'displays a flash message' do
        expect(flash).to be_any
      end
    end

    context 'when you have not logged in' do
      it 'does not empty flash messages' do
        patch recipe_path(recipe), params: { recipe: { title: 'title',
          ingredient: 'ingredient',
          duration: 30,
          cost: 900 } }
        expect(flash).to_not be_empty
      end

      it 'redirects to login page' do
        patch recipe_path(recipe), params: { recipe: { title: 'title',
          ingredient: 'ingredient',
          duration: 30,
          cost: 900 } }
        expect(response).to redirect_to login_path
      end
    end

    context 'when you edit a recipe of other users' do
      let(:other_recipe) { FactoryBot.create(:most_recent) }

      before do
        log_in user
        patch recipe_path(other_recipe), params: { recipe: { title: 'title',
          ingredient: 'ingredient',
          duration: 30,
          cost: 900 } }
      end

      it 'empty the flash message' do
        expect(flash).to be_empty
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end
  end
 
  describe 'DELETE /recipes/{id} #destroy' do
    let!(:user) { FactoryBot.create(:user) }

    context 'when you delete your recipe' do
      let!(:my_recipe) {FactoryBot.create(:recipe, user_id: user.id)}

      it 'can delete recipes' do
        log_in user
        expect {
          delete recipe_path(my_recipe)
        }.to change(Recipe, :count).by -1
      end

      it 'does not empty the flash message' do
        log_in user
        delete recipe_path(my_recipe)
        expect(flash).to_not be_empty
      end

      it 'redirects to root path' do
        log_in user
        delete recipe_path(my_recipe)
        expect(response).to redirect_to root_path
      end
    end
 
    context "when you try to delete another user's recipe" do
      before do
        log_in user
        @recipe = FactoryBot.create(:most_recent)
      end
 
      it 'does not remove' do
        expect {
          delete recipe_path(@recipe)
        }.to_not change(Recipe, :count)
      end
 
      it 'redirects to root path' do
        delete recipe_path(@recipe)
        expect(response).to redirect_to root_path
      end
    end
 
    context 'when you have not logged in' do
      before do
        @recipe = FactoryBot.create(:most_recent)
      end

      it 'does not remove' do
        expect {
          delete recipe_path(@recipe)
        }.to_not change(Recipe, :count)
      end
 
      it 'redirects to root path' do
        delete recipe_path(@recipe)
        expect(response).to redirect_to login_path
      end
    end
  end

  describe 'GET /search #search' do
    let!(:user) {FactoryBot.create(:user)}
    let!(:recipe) {FactoryBot.create(:recipe, user_id: user.id)}

    it 'responds successfully' do
      get search_path, params: {keyword: "レシピタイトル"}
      expect(response).to be_successful
    end

    context 'when there is matching data' do
      it 'can search keywords from the title' do
        expect(Recipe.search("レシピタイトル")).to include(recipe)
      end
  
      it 'can search keywords from the body' do
        expect(Recipe.search("レシピの作り方、説明が入ります")).to include(recipe)
      end
    end
    context 'when there is no matching data' do
      it 'cannot search' do
        expect(Recipe.search("あああ")).to be_empty
      end
    end
  end

  describe 'GET /short_time #short_time' do
    it 'responds successfully' do
      get short_time_path
      expect(response).to be_successful
    end
  end

  describe 'GET /low_cost #low_cost' do
    it 'responds successfully' do
      get low_cost_path
      expect(response).to be_successful
    end
  end

  describe 'GET /following_user_recipes #following_user' do
    it 'responds successfully' do
      user = FactoryBot.create(:user)
      log_in user
      get following_user_recipes_path
      expect(response).to be_successful
    end
  end
end