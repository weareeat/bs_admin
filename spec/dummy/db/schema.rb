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

ActiveRecord::Schema.define(:version => 20160303191139) do

  create_table "bs_admin_assets", :force => true do |t|
    t.string   "type"
    t.string   "group"
    t.string   "file"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "bs_admin_boolean_settings", :force => true do |t|
    t.string   "type"
    t.integer  "setting_sub_group_id"
    t.string   "key"
    t.string   "display_name"
    t.string   "hint"
    t.boolean  "has_user_changed",     :default => false
    t.boolean  "value"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  create_table "bs_admin_setting_groups", :force => true do |t|
    t.string   "key"
    t.string   "display_name"
    t.text     "hint"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "bs_admin_setting_sub_groups", :force => true do |t|
    t.string   "key"
    t.string   "display_name"
    t.string   "main_group"
    t.text     "hint"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "setting_group_id"
  end

  create_table "bs_admin_string_settings", :force => true do |t|
    t.string   "type"
    t.integer  "setting_sub_group_id"
    t.string   "key"
    t.string   "display_name"
    t.string   "hint"
    t.boolean  "has_user_changed",     :default => false
    t.string   "value"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  create_table "bs_admin_text_settings", :force => true do |t|
    t.string   "type"
    t.integer  "setting_sub_group_id"
    t.string   "key"
    t.string   "display_name"
    t.string   "hint"
    t.boolean  "has_user_changed",     :default => false
    t.text     "value"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  create_table "spec_admin_json_api_tests", :force => true do |t|
    t.string   "required_param"
    t.string   "non_required_param"
    t.string   "hidden_param"
    t.string   "protected_param"
    t.string   "view_type_param"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "spec_create_all_types_tests", :force => true do |t|
    t.text     "custom_param"
    t.boolean  "checkbox_param"
    t.string   "email_param"
    t.string   "password_param"
    t.string   "string_param"
    t.integer  "currency_param_cents",    :default => 0,     :null => false
    t.string   "currency_param_currency", :default => "USD", :null => false
    t.string   "permalink_param"
    t.text     "text_param"
    t.date     "date_param"
    t.string   "image_param"
    t.string   "radiogroup_param"
    t.time     "time_param"
    t.datetime "datetime_param"
    t.float    "number_param"
    t.string   "select_param"
    t.text     "wysi_param"
    t.string   "file_param"
    t.integer  "money_param_cents",       :default => 0,     :null => false
    t.string   "money_param_currency",    :default => "USD", :null => false
    t.integer  "integer_param"
    t.string   "color_picker_param"
    t.string   "tags_param"
    t.text     "view_param"
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

end
