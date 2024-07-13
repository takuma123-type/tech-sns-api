class CreateFollowers < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :followers, id: :uuid do |t|
      t.uuid :follower_id, null: false
      t.uuid :followed_id, null: false
      t.timestamps
    end

    add_foreign_key :followers, :users, column: :follower_id, primary_key: :id
    add_foreign_key :followers, :users, column: :followed_id, primary_key: :id
  end
end
