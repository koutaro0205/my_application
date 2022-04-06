class AddTagToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :tag, :integer
  end
end
