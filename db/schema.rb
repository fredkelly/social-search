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

ActiveRecord::Schema.define(:version => 20130209113505) do

  create_table "results", :force => true do |t|
    t.string   "title"
    t.string   "url"
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
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "searches", ["session_id"], :name => "index_searches_on_session_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.string   "remote_addr"
    t.string   "accept_language"
    t.string   "user_agent"
    t.string   "accept_charset"
    t.string   "accept"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "app_version"
  end

  add_index "sessions", ["app_version"], :name => "index_sessions_on_app_version"
  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"

end
