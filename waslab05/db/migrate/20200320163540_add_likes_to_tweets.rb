class AddLikesToTweets < ActiveRecord::Migration[6.0]
  def change
    add_column :tweets, :likes, :int, default: 0
  end
end
