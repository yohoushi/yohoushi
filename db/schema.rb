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

ActiveRecord::Schema.define(version: 20141216115735) do

  create_table "nodes", force: true do |t|
    t.string   "type"
    t.string   "path",           limit: 768,                null: false
    t.string   "description"
    t.boolean  "visible",                    default: true, null: false
    t.boolean  "complex"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
    t.integer  "ancestry_depth",             default: 0
  end

  add_index "nodes", ["ancestry"], name: "index_nodes_on_ancestry", using: :btree
  add_index "nodes", ["path"], name: "index_nodes_on_path", length: {"path"=>255}, using: :btree
  add_index "nodes", ["type", "ancestry"], name: "index_nodes_on_type_and_ancestry", using: :btree
  add_index "nodes", ["type", "path"], name: "index_nodes_on_type_and_path", length: {"type"=>nil, "path"=>255}, using: :btree

  create_table "taggings", force: true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree

  create_table "tags", force: true do |t|
    t.string  "name"
    t.integer "taggings_count", default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

end
