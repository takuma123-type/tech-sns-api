class CreatePostTags < ActiveRecord::Migration[7.0]
  def change
    create_table :post_tags, id: :uuid do |t|
      t.uuid :post_id, null: false
      t.uuid :tag_id, null: false
      t.timestamps
    end

    add_foreign_key :post_tags, :posts, column: :post_id, primary_key: :id
    add_foreign_key :post_tags, :tags, column: :tag_id, primary_key: :id
  end
end
