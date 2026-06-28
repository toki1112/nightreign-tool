# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_06_28_203255) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "bosses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "icon"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "map_objects", force: :cascade do |t|
    t.bigint "boss_id"
    t.datetime "created_at", null: false
    t.integer "floor"
    t.bigint "map_pattern_id", null: false
    t.bigint "outpost_id"
    t.string "position_name"
    t.datetime "updated_at", null: false
    t.integer "x"
    t.integer "y"
    t.index ["boss_id"], name: "index_map_objects_on_boss_id"
    t.index ["map_pattern_id"], name: "index_map_objects_on_map_pattern_id"
    t.index ["outpost_id"], name: "index_map_objects_on_outpost_id"
  end

  create_table "map_patterns", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.bigint "night_lord_id", null: false
    t.integer "pattern_no"
    t.bigint "terrain_change_id", null: false
    t.datetime "updated_at", null: false
    t.index ["night_lord_id"], name: "index_map_patterns_on_night_lord_id"
    t.index ["terrain_change_id"], name: "index_map_patterns_on_terrain_change_id"
  end

  create_table "night_lords", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "icon"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "outposts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "icon"
    t.string "name"
    t.integer "outpost_attribute"
    t.datetime "updated_at", null: false
  end

  create_table "terrain_changes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "crypted_password"
    t.string "email", null: false
    t.string "name", null: false
    t.string "salt"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "map_objects", "bosses"
  add_foreign_key "map_objects", "map_patterns"
  add_foreign_key "map_objects", "outposts"
  add_foreign_key "map_patterns", "night_lords"
  add_foreign_key "map_patterns", "terrain_changes"
end
