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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130527074759) do

  create_table "graphs", force: true do |t|
    t.string   "path",       limit: 2048
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "graphs_tags", id: false, force: true do |t|
    t.integer "graph_id", null: false
    t.integer "tag_id",   null: false
  end

  add_index "graphs_tags", ["graph_id", "tag_id"], name: "index_graphs_tags_on_graph_id_and_tag_id", unique: true, using: :btree

  create_table "tags", force: true do |t|
    t.string   "tag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
