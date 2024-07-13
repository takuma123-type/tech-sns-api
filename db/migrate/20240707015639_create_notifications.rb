class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :notifications, id: :uuid do |t|
      t.uuid :user_id, null: false
      t.uuid :notifiable_id, null: false
      t.string :notifiable_type, null: false
      t.string :type, null: false
      t.timestamps
    end

    add_foreign_key :notifications, :users, column: :user_id, primary_key: :id
  end
end
