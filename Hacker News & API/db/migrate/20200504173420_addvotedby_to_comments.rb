class AddvotedbyToComments < ActiveRecord::Migration[6.0]
  def change
    add_column :comments, :votedby, :string
  end
end
