class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.string :text
      t.integer :submit_id
      t.string :user_id
      t.integer :votes
      t.string :nomautor

      t.timestamps
    end
  end
end
