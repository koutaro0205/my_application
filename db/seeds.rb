# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)
# guest user
# User.create!(name:  "Guest User",
#   email: "guestuser@example.com",
#   password:              "guestuser",
#   password_confirmation: "guestuser",
#   activated: true,
#   activated_at: Time.zone.now)

# User.create!(name:  "Admin User",
#   email: "adminuser@example.com",
#   password:              "adminuser",
#   password_confirmation: "adminuser",
#   admin: true,
#   activated: true,
#   activated_at: Time.zone.now)

# 40.times do |n|
#   name  = Faker::Name.name
#   email = "example-#{n+1}@example.org"
#   password = "password"
#   User.create!(name:  name,
#                 email: email,
#                 password:              password,
#                 password_confirmation: password,
#                 activated: true)
# end

# users = User.order(:created_at).take(10)
# 6.times do
#   title = "レシピのタイトル"
#   ingredient = "・材料1\r\n・材料2\r\n・材料3\r\n・材料4\r\n\r\n・調味料1\r\n・調味料2\r\n・調味料3"
#   body = "レシピの作り方・説明が入ります。\r\nレシピの作り方・説明が入ります。レシピの作り方・説明が入ります。レシピの作り方・説明が入ります。\r\nレシピの作り方・説明が入ります。レシピの作り方・説明が入ります。\r\nレシピの作り方・説明が入ります。レシピの作り方・説明が入ります。レシピの作り方・説明が入ります。レシピの作り方・説明が入ります。\r\nレシピの作り方・説明が入ります。レシピの作り方・説明が入ります。\r\nレシピの作り方・説明が入ります。\r\nレシピの作り方・説明が入ります。レシピの作り方・説明が入ります。\r\nレシピの作り方・説明が入ります。レシピの作り方・説明が入ります。レシピの作り方・説明が入ります。レシピの作り方・説明が入ります。"
#   cost = 900
#   duration = 20
#   tag = 1
#   users.each { |user| user.recipes.create!(title: title, ingredient: ingredient, body: body, cost: cost, duration: duration, tag: tag) }
# end
# # 肉、魚介、大豆、乳製品、ごはんもの、麺、パン、卵、野菜、汁物、鍋、ドリンク類、その他
# Category.create!(
#   name: '肉'
# )
# Category.create!(
#   name: '魚介'
# )
# Category.create!(
#   name: '大豆'
# )
# Category.create!(
#   name: '乳製品'
# )
Category.create!(
  name: 'ご飯もの'
)
Category.create!(
  name: '麺'
)
Category.create!(
  name: 'パン'
)
Category.create!(
  name: '卵料理'
)
Category.create!(
  name: '野菜'
)
Category.create!(
  name: '汁物'
)
Category.create!(
  name: '鍋'
)
Category.create!(
  name: 'ドリンク類'
)
Category.create!(
  name: 'その他'
)