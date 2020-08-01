class AddVotedbyToSubmit < ActiveRecord::Migration[6.0]
  def change
    add_column :submits, :votedby, :string, array: true, default: '{}'
  end
end
