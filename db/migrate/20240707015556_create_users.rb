class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :users, id: :uuid do |t|
      t.string :code, limit: 36
      t.string :email, limit: 255, null: false
      t.string :password, limit: 255, null: false
      t.string :name, limit: 255
      t.binary :avatar_data
      t.string :description, limit: 2500
      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
