class CreateTags < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :tags, id: :uuid do |t|
      t.string :name, limit: 50, null: false

      t.timestamps
    end
  end
end