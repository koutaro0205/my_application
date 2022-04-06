class RemoveTagFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :tag, :integer
  end
end
