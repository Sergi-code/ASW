class AddreplyidToReplies < ActiveRecord::Migration[6.0]
  def change
    add_column :replies, :replyid, :integer
  end
end
