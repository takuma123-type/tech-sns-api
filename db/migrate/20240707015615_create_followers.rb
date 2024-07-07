class CreateFollowers < ActiveRecord::Migration[7.0]
  def change
    create_table :followers, id: :string do |t|
      t.string :follower_id, limit: 36, null: false
      t.string :followed_id, limit: 36, null: false
      t.timestamps
    end

    add_foreign_key :followers, :users, column: :follower_id, primary_key: :id
    add_foreign_key :followers, :users, column: :followed_id, primary_key: :id
  end
end
