class CreateRecipes < ActiveRecord::Migration[7.0]
  def change
    create_table :recipes, options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8mb4' do |t|
      t.text :title
      t.text :ingredient
      t.text :body
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :recipes, [:user_id, :created_at]
  end
end
