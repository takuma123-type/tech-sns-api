class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :posts, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.string :code, limit: 36
      t.string :content, limit: 255, null: false
      t.timestamps
    end

    add_foreign_key :posts, :users, column: :user_id, primary_key: :id
  end
end
