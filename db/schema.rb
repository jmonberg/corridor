# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090502175729) do

  create_table "abuses", :force => true do |t|
    t.string   "abused_type"
    t.integer  "abused_id"
    t.integer  "reporting_user_id"
    t.text     "notes"
    t.integer  "abuse_count",       :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "moderator_id"
  end

  create_table "apositivevotes", :force => true do |t|
    t.integer  "story_id"
    t.integer  "article_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "articles", :force => true do |t|
    t.string   "category"
    t.string   "title"
    t.string   "author"
    t.text     "body"
    t.string   "imglink1"
    t.string   "imglink2"
    t.string   "caption1"
    t.string   "caption2"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "votes_count",       :default => 0
    t.datetime "suspended_at"
    t.string   "suspension_status"
  end

  add_index "articles", ["user_id"], :name => "index_articles_on_user_id"

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.text     "body"
    t.datetime "disabled_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "suspended_at"
    t.string   "suspension_status"
  end

  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "feed_articles", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.string   "permalink"
    t.datetime "date_posted"
    t.integer  "feed_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feeds", :force => true do |t|
    t.string   "site_url",   :default => "", :null => false
    t.string   "feed_url",   :default => "", :null => false
    t.string   "site_name",  :default => "", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", :force => true do |t|
    t.string   "title"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.date     "suspended_at"
    t.text     "suspension_notes"
  end

  create_table "maps", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "category"
    t.text     "comment"
    t.integer  "ref_id"
    t.decimal  "latitude",   :precision => 15, :scale => 10
    t.decimal  "longitude",  :precision => 15, :scale => 10
  end

  add_index "maps", ["user_id"], :name => "index_maps_on_user_id"

  create_table "stories", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.string   "location"
    t.string   "username"
    t.integer  "user_id"
    t.string   "image_url"
    t.datetime "suspended_at"
    t.string   "suspension_status"
  end

  add_index "stories", ["user_id"], :name => "index_stories_on_user_id"

  create_table "sub_articles", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.string   "author"
    t.string   "tags"
    t.string   "link1"
    t.string   "link2"
    t.integer  "article_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "caption1"
    t.string   "caption2"
    t.string   "category"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type"], :name => "index_taggings_on_taggable_id_and_taggable_type"

  create_table "taggs", :force => true do |t|
    t.string   "title"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.string   "user_id"
    t.datetime "disabled_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "totem_events", :force => true do |t|
    t.string   "author"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title"
    t.integer  "action_id"
    t.string   "action_type"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "crypted_password"
    t.string   "password_salt"
    t.string   "persistence_token"
    t.integer  "login_count"
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
    t.string   "email"
    t.text     "profile"
    t.string   "display_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role",              :default => 1
    t.date     "suspended_at"
    t.text     "suspension_notes"
  end

  create_table "votes", :force => true do |t|
    t.integer  "article_id"
    t.boolean  "positive",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
