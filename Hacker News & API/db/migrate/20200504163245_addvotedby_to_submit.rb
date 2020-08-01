class AddvotedbyToSubmit < ActiveRecord::Migration[6.0]
  def change
     add_column :submits, :votedby, :string
  end
end
