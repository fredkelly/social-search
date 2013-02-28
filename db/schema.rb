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

ActiveRecord::Schema.define(:version => 20130228114933) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "comments", :force => true do |t|
    t.integer  "search_id"
    t.text     "comment"
    t.integer  "rating"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "results", :force => true do |t|
    t.string   "title"
    t.text     "url"
    t.integer  "search_id"
    t.text     "description"
    t.datetime "selected_at"
    t.integer  "position"
    t.string   "source_engine"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "results", ["search_id"], :name => "index_results_on_search_id"
  add_index "results", ["source_engine"], :name => "index_results_on_source_engine"

  create_table "searches", :force => true do |t|
    t.string   "query"
    t.integer  "session_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "results_count", :default => 0
  end

  add_index "searches", ["session_id"], :name => "index_searches_on_session_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.string   "remote_ip"
    t.string   "accept_language"
    t.string   "user_agent"
    t.string   "accept_charset"
    t.string   "accept"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.datetime "app_version"
    t.string   "referer"
  end

  add_index "sessions", ["app_version"], :name => "index_sessions_on_app_version"
  add_index "sessions", ["referer"], :name => "index_sessions_on_referer"
  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"

end
