class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, options: 'DEFAULT CHARSET=utf8mb4' do |t|
      t.string :name
      t.string :email

      t.timestamps
    end
  end
end
