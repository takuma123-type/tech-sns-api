class CreateNotifications < ActiveRecord::Migration[7.0]
  def change
    create_table :notifications, id: :string do |t|
      t.string :user_id, limit: 36, null: false
      t.string :notifiable_id, limit: 36, null: false
      t.string :notifiable_type, null: false
      t.string :type, null: false
      t.timestamps
    end

    add_foreign_key :notifications, :users, column: :user_id, primary_key: :id
  end
end
