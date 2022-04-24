require 'rails_helper'

describe User do
  # 有効なファクトリを持つこと
    it "has a valid factory" do
      expect(FactoryBot.build(:user)).to be_valid
    end
  end

RSpec.describe User, type: :model do
  # 名前、メール、パスワードがあれば有効な状態であること
  it "is valid with a name, email, and password" do
    user = FactoryBot.build(:user)
    expect(user).to be_valid
  end
  # 名前がなければ無効な状態であること
  it "is invalid without a name" do
    user = FactoryBot.build(:user, name: nil)
    user.valid?
    expect(user.errors[:name]).to include("を入力してください")
  end
  # 名前の文字数が50文字以内でなければ無効であること
  it "is invalid unless the number of characters in the name is 50 or less" do
    user = FactoryBot.build(:user, name: "a" * 51)
    user.valid?
    expect(user.errors[:name]).to include("は50文字以内で入力してください")
  end
  # メールアドレスがなければ無効な状態であること
  it "is invalid without an email address" do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("を入力してください")
  end
  # メールアドレスの文字数が255文字以内であること
  it "is invalid unless the number of characters in the email is 255 or less" do
    user = FactoryBot.build(:user, email: "#{"a" * 256}@example.com")
    user.valid?
    expect(user.errors[:email]).to include("は255文字以内で入力してください")
  end
  # メールアドレスが特定のフォーマットに沿っていない場合は無効であること
  it "is invalid if email address does not conform to a specific format" do
    user = FactoryBot.build(:user)
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
      foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      user.email = invalid_address
      user.valid?
      expect(user.errors[:email]).to include("は不正な値です")
    end
  end
  # メールアドレスが特定のフォーマットに沿っていれば有効であること
  it "is valid if the email address conforms to a specific format" do
    user = FactoryBot.build(:user)
    valid_addresses = %w[user@exmple.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      user.email = valid_address
      user.valid?
      expect(user).to be_valid
    end
  end
  # 重複したメールアドレスなら無効な状態であること
  it "is invalid with a duplicate email address" do
    FactoryBot.create(:user, email: "duplicated@example.com")
    user = FactoryBot.build(:user, email: "duplicated@example.com")
    user.valid?
    expect(user.errors[:email]).to include("はすでに存在します")
  end
  # パスワードがなければ無効であること
  it "is invalid without a password" do
    user = FactoryBot.build(:user, password: nil)
    user.valid?
    expect(user.errors[:password]).to include("を入力してください")
  end
  # パスワードが6文字以上でなければ無効であること
  it "is invalid unless the number of characters in the password is 6 or more" do
    user = FactoryBot.build(:user, password: "a" * 5)
    user.valid?
    expect(user.errors[:password]).to include("は6文字以上で入力してください")
  end
  # パスワードの入力内容と一致しない場合は無効
  it "is invalid if it does not match the password entered" do
    user = FactoryBot.build(:user, password_confirmation: "powerful")
    user.valid?
    expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
  end

  it "is valid if the email address is lowercase" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    user = FactoryBot.build(:user, email: mixed_case_email)
    user.save
    expect(user.reload.email).to eq(mixed_case_email.downcase)
  end

  #ユーザーは多くの投稿を持つことができる
  it "can have many recipes" do
    user = FactoryBot.create(:user, :with_recipes)
    expect(user.recipes.length).to eq 5
  end

  #ユーザーは多くのコメントを持つことができる
  it "can have many comments" do
    user = FactoryBot.create(:user, :with_comments)
    expect(user.comments.length).to eq 5
  end

  #ユーザーは多くのお気に入りを持つことができる
  it "can have many favorites" do
    user = FactoryBot.create(:user, :with_favorites)
    expect(user.favorites.length).to eq 7
  end

  describe '#favorite' do
    let(:recipe_by_user1) {FactoryBot.create(:recipe_by_user1)}
    let(:recipe_by_user2) {FactoryBot.create(:recipe_by_user2)}
    let(:user1){recipe_by_user1.user}
    let(:user2){recipe_by_user2.user}

    it 'sets favorites? to true if it is a favorite' do
      expect(user1.favorite?(recipe_by_user2)).to_not be_truthy
      user1.favorite(recipe_by_user2)
      expect(user1.favorite?(recipe_by_user2)).to be_truthy
      expect(recipe_by_user2.user_favorites.include?(user1)).to be_truthy
    end

    it 'sets favorites? to false if it is a unfavorite' do
      user1.favorite(recipe_by_user2)
      expect(user1.favorite?(recipe_by_user2)).to_not be_falsey
      user1.unfavorite(recipe_by_user2)
      expect(user1.favorite?(recipe_by_user2)).to be_falsey
    end
  end

  describe '#authenticated?' do
    let(:user) { FactoryBot.build(:user) }
    it 'returns false if digest is nil' do
      expect(user.authenticated?(:remember, '')).to be_falsy
    end
  end

  describe '#follow and #unfollow' do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:other_user) }
   
    it 'follows to set following? to true' do
      expect(user.following?(other_user)).to_not be_truthy
      user.follow(other_user)
      expect(user.following?(other_user)).to be_truthy
      expect(other_user.followers.include?(user)).to be_truthy
    end
   
    it 'unfollows to set following? to false' do
      user.follow(other_user)
      expect(user.following?(other_user)).to_not be_falsey
      user.unfollow(other_user)
      expect(user.following?(other_user)).to be_falsey
    end
  end

  describe 'home#feed' do
    let(:recipe_by_user1) {FactoryBot.create(:recipe_by_user1)}
    let(:recipe_by_user2) {FactoryBot.create(:recipe_by_user2)}
    let(:recipe_by_user3) {FactoryBot.create(:recipe_by_user3)}
    let(:user1){recipe_by_user1.user}
    let(:user2){recipe_by_user2.user}
    let(:user3){recipe_by_user3.user}

    it 'includes the posts of the users you follow in your feed' do
      user1.follow(user2)
      user2.recipes.each do |recipe_following|
        expect(user1.following_ids.include?(recipe_following.user_id)).to be_truthy
      end
    end

    it 'does not include posts from unfollowed users in the feed' do
      user1.follow(user2)
      user3.recipes.each do |recipe_unfollowed|
        expect(user1.following_ids.include?(recipe_unfollowed.user_id)).to be_falsey
      end
    end
  end
end
