class CreateLikes < ActiveRecord::Migration[7.0]
  def change
    create_table :likes, id: :string do |t|
      t.string :user_id, limit: 36, null: false
      t.string :post_id, limit: 36, null: false
      t.timestamps
    end

    add_foreign_key :likes, :users, column: :user_id, primary_key: :id
    add_foreign_key :likes, :posts, column: :post_id, primary_key: :id
  end
end
