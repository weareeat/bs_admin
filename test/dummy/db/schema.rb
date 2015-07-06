# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20150701214958) do

  create_table "bs_admin_assets", :force => true do |t|
    t.string   "type"
    t.string   "group"
    t.string   "file"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "bs_admin_boolean_settings", :force => true do |t|
    t.string   "type"
    t.integer  "setting_group_id"
    t.string   "key"
    t.string   "display_name"
    t.string   "hint"
    t.boolean  "has_user_changed", :default => false
    t.boolean  "value"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  create_table "bs_admin_setting_groups", :force => true do |t|
    t.string   "key"
    t.string   "display_name"
    t.string   "main_group"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "bs_admin_string_settings", :force => true do |t|
    t.string   "type"
    t.integer  "setting_group_id"
    t.string   "key"
    t.string   "display_name"
    t.string   "hint"
    t.boolean  "has_user_changed", :default => false
    t.string   "value"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  create_table "bs_admin_text_settings", :force => true do |t|
    t.string   "type"
    t.integer  "setting_group_id"
    t.string   "key"
    t.string   "display_name"
    t.string   "hint"
    t.boolean  "has_user_changed", :default => false
    t.text     "value"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.integer  "post_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
