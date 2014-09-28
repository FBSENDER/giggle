class CreateIdioms < ActiveRecord::Migration
  def change
    create_table :idioms do |t|
      t.string  "keyword"
      t.integer "level"
      t.integer "page"
      t.text    "descriptions"
      t.datetime  "created_at"
      t.datetime  "updated_at"
    end
    
    add_index "idioms", ["level","page"], name: "ix_level_page", using: :btree

  end
end
