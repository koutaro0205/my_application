class AddColumnToRecipes < ActiveRecord::Migration[7.0]
  def change
    add_column :recipes, :duration, :integer
    add_column :recipes, :cost, :integer
  end
end
