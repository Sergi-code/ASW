class AddTokenToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :oauth_token, :string
    add_column :users, :string, :string
  end
end
