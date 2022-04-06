class AddTagToRecipes < ActiveRecord::Migration[7.0]
  def change
    add_column :recipes, :tag, :integer
  end
end
