class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts, id: :string do |t|
      t.string :user_id, limit: 36, null: false
      t.string :code, limit: 36
      t.string :content, limit: 255, null: false
      t.timestamps
    end

    add_foreign_key :posts, :users, column: :user_id, primary_key: :id
  end
end
