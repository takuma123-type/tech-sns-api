class CreateLikes < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :likes, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :post_id, null: false
      t.timestamps
    end

    add_foreign_key :likes, :users, column: :user_id, primary_key: :id
    add_foreign_key :likes, :posts, column: :post_id, primary_key: :id
  end
end
