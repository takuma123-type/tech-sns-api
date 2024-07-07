class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, id: :string do |t|
      t.string :code, limit: 36
      t.string :email, limit: 255, null: false
      t.string :password, limit: 255, null: false
      t.string :name, limit: 255, null: false
      t.string :avatar_url, limit: 255
      t.string :description, limit: 2500
      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end