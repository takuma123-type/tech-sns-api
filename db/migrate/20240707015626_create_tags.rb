class CreateTags < ActiveRecord::Migration[7.0]
  def change
    create_table :tags, id: :string do |t|
      t.string :name, limit: 50, null: false

      t.timestamps
    end
  end
end
