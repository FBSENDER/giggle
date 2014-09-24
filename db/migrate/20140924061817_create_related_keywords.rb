class CreateRelatedKeywords < ActiveRecord::Migration
  def change
    create_table :related_keywords do |t|
      t.string  "keyword_string"
      t.string  "suggestions"
      t.string  "related_keywords"
      t.boolean "is_popular"
      t.datetime  "created_at"
      t.datetime  "updated_at"
    end

    add_index "related_keywords", ["keyword_string"], name: "ix_keyword_string", using: :btree
  end
end
