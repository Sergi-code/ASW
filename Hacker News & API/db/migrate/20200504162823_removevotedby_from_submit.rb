class RemovevotedbyFromSubmit < ActiveRecord::Migration[6.0]
  def change
    remove_column :submits, :votedby, :string, array: true, default: '{}'
  end
end
