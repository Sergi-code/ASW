class CreateReplies < ActiveRecord::Migration[6.0]
  def change
    create_table :replies do |t|
      t.string :text
      t.integer :comment_id
      t.string :user_id
      t.integer :votes
      t.string :nomautor
      t.string :votedby

      t.timestamps
    end
  end
end
