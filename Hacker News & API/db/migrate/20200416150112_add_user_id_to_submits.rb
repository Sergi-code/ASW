class AddUserIdToSubmits < ActiveRecord::Migration[6.0]
  def change
    add_column :submits, :user_id, :string
  end
end
