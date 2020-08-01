class CreateSubmits < ActiveRecord::Migration[6.0]
  def change
    create_table :submits do |t|
      t.string :title
      t.string :url
      t.string :text
      t.string :userpost
      t.integer :votes
      t.timestamps
    end
  end
end
